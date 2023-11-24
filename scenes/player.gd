extends CharacterBody2D
	
var player_movement = true
var tileSize = 32
var playerMovementFrameCtr = 0
var impassableArray = [1,2]
var direction = ""
var playerHP = 20
var maxPlayerHP = 20
var playerExp = 0

signal infobox_movement

@onready var tileMap = get_parent().get_node('TileMap')
@onready var infoBox = get_parent().get_node('Infobox')
@onready var infoBox2 = get_parent().get_node('Infobox2')
@onready var messageBox = get_parent().get_node('MessageBox')

func _physics_process(delta):
	# check for keyboard input
	read_input()
	
	handle_frame_counter()
	
	update_infoboxes()
	
func read_input():
	if playerMovementFrameCtr == 0:
		var collisionCheckX = position.x
		var collisionCheckY = position.y
		if Input.is_action_pressed("up"):
			direction = "up"
			collisionCheckY -= tileSize
			player_movement = true
		elif Input.is_action_pressed("down"):
			direction = "down"
			collisionCheckY += tileSize
			player_movement = true
		elif Input.is_action_pressed("left"):
			direction = "left"
			collisionCheckX -= tileSize
			player_movement = true
		elif Input.is_action_pressed("right"):
			direction = "right"
			collisionCheckX += tileSize
			player_movement = true

		if player_movement:
			var bool = is_tile_passable(collisionCheckX,collisionCheckY)
			if bool:
				position.x = collisionCheckX
				position.y = collisionCheckY
				playerMovementFrameCtr = 1
				
				# update info box positions
				var messageBoxText = messageBox.get_node('MarginContainer').get_node('Label')
				
				if direction == "up":
					infoBox.position.y -= tileSize
					infoBox2.position.y -= tileSize
					messageBox.position.y -= tileSize
					messageBoxText.set_text("Move up")
				if direction == "down":
					infoBox.position.y += tileSize
					infoBox2.position.y += tileSize
					messageBox.position.y += tileSize
					messageBoxText.set_text("Move down")
				if direction == "left":
					infoBox.position.x -= tileSize
					infoBox2.position.x -= tileSize
					messageBox.position.x -= tileSize
					messageBoxText.set_text("Move left")
				if direction == "right":
					infoBox.position.x += tileSize
					infoBox2.position.x += tileSize
					messageBox.position.x += tileSize
					messageBoxText.set_text("Move right")

			player_movement = false
	else:
		if Input.is_action_just_released("up"):
			playerMovementFrameCtr = 0
		if Input.is_action_just_released("down"):
			playerMovementFrameCtr = 0
		if Input.is_action_just_released("left"):
			playerMovementFrameCtr = 0
		if Input.is_action_just_released("right"):
			playerMovementFrameCtr = 0	

func handle_frame_counter():
	# control player movement against 60 FPS so they don't fly off the screen
	if playerMovementFrameCtr > 0:
		playerMovementFrameCtr += 1
	if playerMovementFrameCtr >= 9:
		playerMovementFrameCtr = 0	
		
func is_tile_passable(collisionCheckX, collisionCheckY):
	var vector = Vector2(collisionCheckX,collisionCheckY)
	var vector2 = tileMap.local_to_map(vector)
	var id2 = tileMap.get_cell_atlas_coords(0,vector2)
	
	if id2.y in impassableArray:
		return false
	else:
		return true
		
func update_infoboxes():
	var hp_label = infoBox.get_node('MarginContainer').get_node('Label')
	hp_label.set_text("HP: " + str(playerHP) + "/" + str(maxPlayerHP))
	var exp_label = infoBox2.get_node('MarginContainer').get_node('Label')
	exp_label.set_text("EXP: " + str(playerExp))
	
