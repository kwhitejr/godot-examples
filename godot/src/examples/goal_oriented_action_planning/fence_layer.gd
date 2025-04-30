extends TileMapLayer

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	#print(true if coords in get_used_cells_by_id(1) else false)
	return true if coords in get_used_cells_by_id(1) else false

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	print("Disable navigation at ", coords)
	tile_data.set_navigation_polygon(0, null)
