extends Node2D
class_name TileMapLayerNavigationRemoval2D

# Reference to the navigation TileMapLayer
@onready var tilemap_layer: TileMapLayer = %BaseGroundLayer

# Cache for modified tiles to restore on exit
var _modified_tiles: Array[Vector2i] = []

func _ready() -> void:
	# Wait until the node is fully added to the scene tree
	await get_tree().process_frame
	
	# Find the tilemap_layer if not set
	if not tilemap_layer and is_inside_tree():
		tilemap_layer = _find_tilemap_layer()
	
	# Validate parent
	var parent = get_parent()
	if not (parent is StaticBody2D or parent is CollisionShape2D):
		print("Warning: Parent is not StaticBody2D or CollisionShape2D, got ", parent)

	# Apply the exclusion
	update_exclusion()

func _set_position(value: Vector2) -> void:
	position = value
	update_exclusion()

func _set_rotation(value: float) -> void:
	rotation = value
	update_exclusion()

func _set_scale(value: Vector2) -> void:
	scale = value
	update_exclusion()

func _exit_tree() -> void:
	# Notify TileMapLayer to remove excluded tiles
	if tilemap_layer and not _modified_tiles.is_empty():
		tilemap_layer.remove_excluded_tiles(_modified_tiles)
	_modified_tiles.clear()

func update_exclusion() -> void:
	if not tilemap_layer:
		return
	
	# Clear previous exclusions
	if not _modified_tiles.is_empty():
		tilemap_layer.remove_excluded_tiles(_modified_tiles)
	_modified_tiles.clear()
	
	# Get overlapping tiles
	var tile_coords = _get_overlapping_tiles()
	_modified_tiles = tile_coords
	
	# Notify TileMapLayer of new excluded tiles
	if not tile_coords.is_empty():
		tilemap_layer.add_excluded_tiles(tile_coords)

func _get_overlapping_tiles() -> Array[Vector2i]:
	var tile_coords: Array[Vector2i] = []
	if not tilemap_layer:
		return tile_coords
	
	var parent = get_parent()
	if parent is StaticBody2D:
		# Check all CollisionShape2D children of the StaticBody2D
		for child in parent.get_children():
			if child is CollisionShape2D and child.shape:
				tile_coords.append_array(_get_tiles_for_collision_shape(child))
	elif parent is CollisionShape2D and parent.shape:
		# Use the parent's CollisionShape2D
		tile_coords.append_array(_get_tiles_for_collision_shape(parent))
	
	return tile_coords

func _get_tiles_for_collision_shape(collision_shape: CollisionShape2D) -> Array[Vector2i]:
	var tile_coords: Array[Vector2i] = []
	var shape = collision_shape.shape
	var global_transform = collision_shape.get_global_transform()
	
	# Compute the bounding box in global coordinates
	var bounds: Rect2
	if shape is RectangleShape2D:
		var extents = shape.extents
		var corners = [
			global_transform * Vector2(-extents.x, -extents.y),
			global_transform * Vector2(extents.x, -extents.y),
			global_transform * Vector2(extents.x, extents.y),
			global_transform * Vector2(-extents.x, extents.y)
		]
		bounds = Rect2(corners[0], Vector2.ZERO)
		for corner in corners:
			bounds = bounds.expand(corner)
	elif shape is CircleShape2D:
		var center = global_transform.get_origin()
		var radius = shape.radius * global_transform.get_scale().x # Assume uniform scale
		bounds = Rect2(center - Vector2(radius, radius), Vector2(radius * 2, radius * 2))
	else:
		# Unsupported shape; skip
		return tile_coords
	
	# Convert bounds to tile coordinates
	var min_tile = tilemap_layer.local_to_map(bounds.position)
	var max_tile = tilemap_layer.local_to_map(bounds.position + bounds.size)
	
	# Check tiles in the bounding box
	for x in range(min_tile.x, max_tile.x + 1):
		for y in range(min_tile.y, max_tile.y + 1):
			var coords = Vector2i(x, y)
			var tile_pos = tilemap_layer.map_to_local(coords)
			var tile_size = tilemap_layer.tile_set.tile_size
			var tile_rect = Rect2(tile_pos - tile_size / 2.0, tile_size)
			
			# Check if the tile overlaps the shape
			if _shape_overlaps_rect(shape, global_transform, tile_rect):
				tile_coords.append(coords)
	
	return tile_coords

func _shape_overlaps_rect(shape: Shape2D, shape_transform: Transform2D, rect: Rect2) -> bool:
	if shape is RectangleShape2D:
		var extents = shape.extents
		var shape_rect = Rect2(shape_transform * Vector2(-extents.x, -extents.y), extents * 2)
		return shape_rect.intersects(rect)
	elif shape is CircleShape2D:
		var center = shape_transform.get_origin()
		var radius = shape.radius * shape_transform.get_scale().x
		var closest_point = rect.position
		closest_point.x = clamp(closest_point.x, rect.position.x, rect.position.x + rect.size.x)
		closest_point.y = clamp(closest_point.y, rect.position.y, rect.position.y + rect.size.y)
		return closest_point.distance_to(center) <= radius
	return false

func _find_tilemap_layer() -> TileMapLayer:
	# Search the entire scene tree from the root
	if not is_inside_tree():
		return null
	
	var root = get_tree().edited_scene_root if Engine.is_editor_hint() else get_tree().root
	if not root:
		return null
	
	# Recursive search for the first TileMapLayer
	var tilemap_layer = _search_node_for_tilemap_layer(root)
	return tilemap_layer

func _search_node_for_tilemap_layer(node: Node) -> TileMapLayer:
	if node is TileMapLayer:
		return node
	
	for child in node.get_children():
		var result = _search_node_for_tilemap_layer(child)
		if result:
			return result
	
	return null
