extends KinematicBody2D

#define a velocity variable to hold our player movement
var velocity = Vector2.ZERO
#define an empty object of no type that we can set to whatever the player is interacting with
var interactiveObject = null
#string variable to keep track of what type of object the player is interacting with
var ioType = ""
#This holds the number of keys the player has, we export it so the world scene has access to them.
export var chestKeys = 0


#These are our open and locked sound effects. We preload them so we dont get a lag delay when they interact with the chest.
#These are very small, so it probably wouldnt matter, but larger/longer audio would have a delay the first time its played 
#if we dont preload it.
var openSound = preload("res://Resources/Sounds/discovery.wav")
var lockedSound = preload("res://Resources/Sounds/shake.wav")

#We setup a variable so we can access the Area2D/CollisionShape2D easier.
onready var detector = $InteractDetector/Detector

#This is the physics process, this runs constantly. This is a built in godot function
func _physics_process(delta):	
	#input_vector variable to keep track of directional input from keyboard/controller
	var input_vector = Vector2.ZERO
	#The ui_right,ui_left, etc are defined under Project Settings > Input Map 
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#Normalize the values. A normalised vector is a vector that points in precisely the same direction as the original vector but has a length of exactly one unit (a unit vector).
	input_vector = input_vector.normalized()
	
	
	#Down
	if input_vector.y == 1:
		#We set the players sprite frame to the frame that makes it face down.
		$Sprite.frame = 2
		#we move the detector to above the players sprite.
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
		velocity = velocity.move_toward(input_vector * 200, 100 * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 5000 * delta)
	velocity = move_and_slide(velocity)


#this is a built in godot function. It allows us to monitor all input.
func _input(event):
	#we check if the event is the ui_select action.
	if(event.is_action_pressed("ui_select")):
		#If our interactiveObject (the thing infront of the player inside the area2d/collisionshape2d) has a value.
		if interactiveObject != null:
			#Added ioType so we could have different interactions, like doors and such. The frameid could be different based on type you are opening
			if ioType == "Chest":
				#we setup a tempChest to hold the chest object, incase the player quickly moves while trying to open
				var tempChest = interactiveObject
				#check to make sure they have a key to open the chest.
				if chestKeys >= 1:
					#here we check the exported variable from the chest scene, isOpened (a boolean)
					#if it isnt opened then we continue. ! before a boolean check means isNot
					if !interactiveObject.isOpened:
						#We set the AudioPlayer2D's stream to the open sound we defined above in the preload.
						$SoundEffect.stream = openSound
						#we update the Sprite on the chest to be its 5th frame, the open frame.
						interactiveObject.get_node("Sprite").frame = 5
						#we update the chest's isOpened flag to true
						interactiveObject.isOpened = true			
						#we tell the Particle2D to play its animation. Which is set as a one shot. So it plays once then ends.	
						interactiveObject.get_node("Contents").emitting = true
						#we remove one key from the players chestKeys count
						chestKeys -= 1
						#we then tell the AudtioPlayer2D to play the sound we loaded.
						$SoundEffect.play()	
				else:	#you dont have enough keys	
					if !interactiveObject.isOpened:
						#using rotation to fake an animation
						$SoundEffect.stream = lockedSound	
						#this simply makes the sprite of the chest rotate by 5 degrees right, then left, then back to none.
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
	#When an object enters the Area2D/Collision2D it checks what Group the object is in
	#If it is in the Chest group, we set our interactiveObject to the body, which is the chest we are looking at
	if body.is_in_group("Chest"):
		interactiveObject = body
		ioType = "Chest"
	#if the object in the area2d/collisionshape2d is in the Key group, we increase the players chestKeys count by 1
	#and then remove the key from the scene.
	if body.is_in_group("Key"):
		chestKeys += 1
		body.queue_free()


func _on_InteractDetector_body_exited(body):
	#this clears out the object when you are no longer looking at it.
	#This prevents you from opening a chest you arent in front of.
	interactiveObject = null
	ioType = ""
