extends KinematicBody2D

var velocity = Vector2.ZERO
var interactiveObject = null
var ioType = ""
export var chestKeys = 0

var openSound = preload("res://Resources/Sounds/discovery.wav")
var lockedSound = preload("res://Resources/Sounds/shake.wav")

onready var detector = $InteractDetector/Detector

func _ready():
	pass # Replace with function body.

func _physics_process(delta):	
	var input_vector = Vector2.ZERO
	#The ui_right,ui_left, etc are defined under Project Settings > Input Map 
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	#Down
	if input_vector.y == 1:
		$Sprite.frame = 2
		detector.position.x = 0
		detector.position.y = 16
	#Up
	if input_vector.y == -1:
		$Sprite.frame = 0
		detector.position.x = 0
		detector.position.y = -16
		
	#Right	
	if input_vector.x == 1:
		$Sprite.frame = 1
		detector.position.x = 16
		detector.position.y = 0
	#Left
	if input_vector.x == -1:
		$Sprite.frame = 3
		detector.position.x = -16
		detector.position.y = 0
		
	
	#If we are pressing a movement key, then move. Else stop.
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * 200, 200 * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 5000 * delta)
	velocity = move_and_slide(velocity)


func _input(event):
	if(event.is_action_pressed("ui_select")):
		if interactiveObject != null:
			#Added ioType so we could have different interactions, like doors and such. The frameid could be different based on type you are opening
			if ioType == "Chest":
				#we setup a tempChest to hold the chest object, incase the player quickly moves while trying to open
				var tempChest = interactiveObject
				if chestKeys >= 1:
					if !interactiveObject.isOpened:
						$SoundEffect.stream = openSound
						interactiveObject.get_node("Sprite").frame = 5
						interactiveObject.isOpened = true				
						interactiveObject.get_node("Contents").emitting = true
						chestKeys -= 1
						$SoundEffect.play()	
				else:	#you dont have enough keys	
					if !interactiveObject.isOpened:
						#using rotation to fake an animation
						$SoundEffect.stream = lockedSound	
						tempChest.get_node("Sprite").rotation_degrees = -5
						yield(get_tree().create_timer(0.08), "timeout")
						tempChest.get_node("Sprite").rotation_degrees = 5
						yield(get_tree().create_timer(0.08), "timeout")
						tempChest.get_node("Sprite").rotation_degrees = 0
						$SoundEffect.play()	
					
				
			if ioType == "Door":
				#this doesnt exist, put here as an example of a door
				interactiveObject.get_node("Sprite").frame = 1


func _on_InteractDetector_body_entered(body):
	if body.is_in_group("Chest"):
		interactiveObject = body
		ioType = "Chest"
	if body.is_in_group("Key"):
		chestKeys += 1
		body.queue_free()


func _on_InteractDetector_body_exited(body):
	interactiveObject = null
	ioType = ""
