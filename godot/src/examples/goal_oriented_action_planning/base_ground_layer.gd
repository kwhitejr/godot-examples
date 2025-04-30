extends TileMapLayer


@onready var forest_layer: TileMapLayer = $"../ForestLayer"
@onready var fence_layer: TileMapLayer = $"../FenceLayer"

# Track tiles excluded by TileMapLayerNavigationRemoval2D using a Dictionary
# Key: Vector2i (tile coordinates), Value: bool (true for excluded)
var _excluded_tiles: Dictionary = {}

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	# Update BaseGround tiles where an obstacle layer has a tile or is excluded
	var is_forest_layer: bool = forest_layer.get_cell_tile_data(coords) != null
	var is_fence_layer: bool = fence_layer.get_cell_tile_data(coords) != null
	var is_excluded: bool = _excluded_tiles.has(coords)
	return is_forest_layer || is_fence_layer || is_excluded

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	# Disable navigation for BaseGround tiles under obstacles or excluded tiles
	tile_data.set_navigation_polygon(0, null)

# Public method for TileMapLayerNavigationRemoval2D to add excluded tiles
func add_excluded_tiles(coords_array: Array[Vector2i]) -> void:
	for coords in coords_array:
		_excluded_tiles[coords] = true
	# Force update of affected tiles
	notify_runtime_tile_data_update()

# Public method for TileMapLayerNavigationRemoval2D to remove excluded tiles
func remove_excluded_tiles(coords_array: Array[Vector2i]) -> void:
	for coords in coords_array:
		_excluded_tiles.erase(coords)
	# Force update of affected tiles
	notify_runtime_tile_data_update()
