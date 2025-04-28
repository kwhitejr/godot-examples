extends Node2D
class_name NavigationRemoval2D

# Exported polygon property for the exclusion area, editable in the 2D UI
@export var polygon: PackedVector2Array = []:
	set(value):
		polygon = value
		update_exclusion()
		if Engine.is_editor_hint():
			notify_property_list_changed() # Notify editor of property change
			queue_redraw() # Update visualization
	get:
		return polygon

# Exported reference to NavigationRegion2D or TileMapLayer
@export var navigation_target: Node = null

# Cache for NavigationRegion2D's original navigation polygon
var _original_nav_polygon: NavigationPolygon
# Cache for TileMapLayer's modified tiles to restore on exit
var _modified_tiles: Dictionary = {} # {Vector2i: TileData}

func _ready() -> void:
	# Wait until the node is fully added to the scene tree
	await get_tree().process_frame
	
	# Find the navigation target if not set
	if not navigation_target and is_inside_tree():
		navigation_target = _find_navigation_target()
	
	# Initialize based on navigation target type
	if navigation_target is NavigationRegion2D and navigation_target.navigation_polygon:
		# Cache the original navigation polygon
		_original_nav_polygon = navigation_target.navigation_polygon.duplicate()
	
	# Apply the exclusion
	update_exclusion()

func _set_position(value: Vector2) -> void:
	position = value
	update_exclusion()
	queue_redraw()

func _set_rotation(value: float) -> void:
	rotation = value
	update_exclusion()
	queue_redraw()

func _set_scale(value: Vector2) -> void:
	scale = value
	update_exclusion()
	queue_redraw()

func _exit_tree() -> void:
	# Clean up based on navigation target
	if navigation_target is NavigationRegion2D and _original_nav_polygon:
		# Restore the original navigation polygon
		navigation_target.navigation_polygon = _original_nav_polygon
	elif navigation_target is TileMapLayer:
		# Restore navigation for modified tiles
		for coords in _modified_tiles:
			var tile_data: TileData = navigation_target.get_cell_tile_data(coords)
			if tile_data:
				tile_data.set_navigation_polygon(0, _modified_tiles[coords])
		_modified_tiles.clear()

func _draw() -> void:
	# Draw the polygon in the editor
	if Engine.is_editor_hint() and not polygon.is_empty():
		var color = Color(1.0, 0.5, 0.0, 0.8) # Orange
		# Draw lines
		for i in range(polygon.size()):
			var p1 = polygon[i]
			var p2 = polygon[(i + 1) % polygon.size()]
			draw_line(p1, p2, color, 2.0)
		# Draw points
		for point in polygon:
			draw_circle(point, 4.0, color)

func update_exclusion() -> void:
	if not navigation_target or polygon.is_empty():
		return
	
	# Transform the polygon to global coordinates
	var transformed_polygon: PackedVector2Array = []
	for point in polygon:
		transformed_polygon.append(get_global_transform() * point)
	
	if navigation_target is NavigationRegion2D and navigation_target.navigation_polygon:
		# Handle NavigationRegion2D: Subtract polygon from navigation polygon
		var nav_polygon: NavigationPolygon = navigation_target.navigation_polygon
		var source_polygon: PackedVector2Array = nav_polygon.get_vertices()
		
		# Subtract the exclusion polygon
		var result_polygons = Geometry2D.clip_polygons(source_polygon, transformed_polygon)
		
		# Update the navigation polygon
		if not result_polygons.is_empty():
			var new_nav_polygon = NavigationPolygon.new()
			new_nav_polygon.add_outline(result_polygons[0]) # Use first clipped polygon
			new_nav_polygon.make_polygons_from_outlines()
			navigation_target.navigation_polygon = new_nav_polygon
	
	elif navigation_target is TileMapLayer:
		# Handle TileMapLayer: Disable navigation for overlapping tiles
		# Restore previously modified tiles
		for coords in _modified_tiles:
			var tile_data: TileData = navigation_target.get_cell_tile_data(coords)
			if tile_data:
				tile_data.set_navigation_polygon(0, _modified_tiles[coords])
		_modified_tiles.clear()
		
		# Find tiles overlapping the transformed polygon
		var tile_coords = _get_overlapping_tiles(transformed_polygon)
		for coords in tile_coords:
			var tile_data: TileData = navigation_target.get_cell_tile_data(coords)
			if tile_data and tile_data.get_navigation_polygon(0):
				# Cache the original navigation polygon
				_modified_tiles[coords] = tile_data.get_navigation_polygon(0)
				# Disable navigation
				tile_data.set_navigation_polygon(0, null)

func _get_overlapping_tiles(global_polygon: PackedVector2Array) -> Array[Vector2i]:
	# Convert global polygon to tile coordinates and find overlapping tiles
	var tile_coords: Array[Vector2i] = []
	if not navigation_target is TileMapLayer:
		return tile_coords
	
	# Get the bounding box of the polygon in global coordinates
	var min_pos = global_polygon[0]
	var max_pos = global_polygon[0]
	for point in global_polygon:
		min_pos = min_pos.min(point)
		max_pos = max_pos.max(point)
	
	# Convert to tile coordinates
	var min_tile = navigation_target.local_to_map(min_pos)
	var max_tile = navigation_target.local_to_map(max_pos)
	
	# Check tiles in the bounding box
	for x in range(min_tile.x, max_tile.x + 1):
		for y in range(min_tile.y, max_tile.y + 1):
			var coords = Vector2i(x, y)
			# Get the tile's global bounding box
			var tile_pos = navigation_target.map_to_local(coords)
			var tile_size = navigation_target.tile_set.tile_size
			var tile_rect = Rect2(tile_pos - tile_size / 2.0, tile_size)
			
			# Check if the tile's bounding box intersects the polygon
			if Geometry2D.is_point_in_polygon(tile_pos, global_polygon) or \
			   _rect_intersects_polygon(tile_rect, global_polygon):
				tile_coords.append(coords)
	
	return tile_coords

func _rect_intersects_polygon(rect: Rect2, polygon: PackedVector2Array) -> bool:
	# Check if the rectangle intersects the polygon
	var rect_points = [
		rect.position,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + rect.size,
		rect.position + Vector2(0, rect.size.y)
	]
	for point in rect_points:
		if Geometry2D.is_point_in_polygon(point, polygon):
			return true
	
	# Check if any polygon edge intersects the rectangle
	for i in range(polygon.size()):
		var p1 = polygon[i]
		var p2 = polygon[(i + 1) % polygon.size()]
		if rect.has_point(p1) or rect.has_point(p2):
			return true
		# Simplified edge intersection check
		for j in range(4):
			var r1 = rect_points[j]
			var r2 = rect_points[(j + 1) % 4]
			if Geometry2D.segment_intersects_segment(p1, p2, r1, r2):
				return true
	
	return false

func _find_navigation_target() -> Node:
	# Search up the tree for a NavigationRegion2D or TileMapLayer
	var current = get_parent()
	while current:
		if current is NavigationRegion2D:
			return current
		if current is TileMapLayer:
			return current
		current = current.get_parent()
	return null
