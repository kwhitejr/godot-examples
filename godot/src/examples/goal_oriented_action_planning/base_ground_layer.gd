extends TileMapLayer


@onready var forest_layer: TileMapLayer = $"../ForestLayer"
@onready var fence_layer: TileMapLayer = $"../FenceLayer"

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	# Update BaseGround tiles where ObstacleLayer has a tile
	var is_forest_layer: bool = forest_layer.get_cell_tile_data(coords) != null
	var is_fence_layer: bool = fence_layer.get_cell_tile_data(coords) != null
	return is_forest_layer || is_fence_layer

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	# Disable navigation for BaseGround tiles under obstacles
	tile_data.set_navigation_polygon(0, null)
