extends CanvasLayer

var tiles = []  # List of TextureButtons
var solved = []  # Solved order of tiles
var first_tile = null  # The first tile clicked
var second_tile = null  # The second tile clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.visible = true
	$Button.visible = false
	tiles = $GridContainer.get_children()  # Get all TextureButtons in the GridContainer
	solved = tiles.duplicate() 
	 # Save the solved order
	# Connect the pressed signal for each button
	# Connect the pressed signal for each TextureButton
	# Connect the pressed signal for each TextureButton
	for tile in tiles:
		tile.connect("pressed", Callable(self, "_on_tile_pressed").bind(tile))  # Connect signal to _on_tile_pressed with the tile as argument
		print("Connected signal for:", tile.name)  # Debug connection

	shuffle_tiles()
	$ResultLabel.visible = false
	$StartLabel.visible = true
	$ColorRect.visible = true
	$GridContainer.visible = false
	print("game ready")

func start_game():
	$ResultLabel.visible = false
	$StartLabel.visible = false
	$StartButton.visible = false
	$ColorRect.visible = true
	$GridContainer.visible = true
	print("game started")

func shuffle_tiles():
	var tile_indices = range(tiles.size())  # Create a list of indices
	tile_indices.shuffle()  # Shuffle the indices

	# Rearrange the tiles in the GridContainer
	for i in range(tile_indices.size()):
		$GridContainer.move_child(tiles[tile_indices[i]], i)  # Move child nodes
	print("tiles shuffled")
 
func _on_tile_pressed(tile: TextureButton):
	if first_tile == null:
		first_tile = tile
	elif second_tile == null:
		second_tile = tile
		swap_tiles(first_tile, second_tile)
		first_tile = null
		second_tile = null
		if tiles_match(solved, $GridContainer.get_children()):
			check_win()
	print("tile clicked:", tile.name)

func swap_tiles(tile_src: TextureButton, tile_dst: TextureButton):
	# Get the children of the GridContainer
	var grid_children = $GridContainer.get_children()
	
	# Find the index of each tile in the GridContainer
	var src_index = grid_children.find(tile_src)
	var dst_index = grid_children.find(tile_dst)
	
	# Check if the tiles exist in the GridContainer
	if src_index != -1 and dst_index != -1:
		# Swap the positions of the tiles
		$GridContainer.move_child(tile_src, dst_index)
		$GridContainer.move_child(tile_dst, src_index)


func tiles_match(arr1, arr2):
	for i in range(arr1.size()):
		if arr1[i] != arr2[i]:
			return false
	return true

func check_win():
	$ColorRect.visible = true
	$ResultLabel.text = "Puzzle Solved"
	$ResultLabel.visible = true
	$GridContainer.visible = true
	$Button.visible = true



func _on_start_button_pressed() -> void:
	start_game()


func _on_button_pressed() -> void:
	return
