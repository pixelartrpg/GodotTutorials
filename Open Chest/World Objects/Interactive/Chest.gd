extends StaticBody2D

export var isOpened = false
export var contains = "Coins"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var texture = ImageTexture.new()
	var image = Image.new()
	if contains == "Coins":
		image.load("res://Resources/Artwork/Objects/coin.png")
		$Contents.process_material.set_emission_shape(1)
		$Contents.process_material.scale = 0.3 
		$Contents.amount = 8
		$Contents.lifetime = 0.8
		$Contents.speed_scale = 2
	if contains == "Armor":
		image.load("res://Resources/Artwork/Objects/armor.png")
		$Contents.process_material.set_emission_shape(0)
		$Contents.process_material.scale = 0.5
		$Contents.amount = 1
		$Contents.lifetime = 2
		$Contents.speed_scale = 0.75
		
	texture.create_from_image(image)
	$Contents.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
