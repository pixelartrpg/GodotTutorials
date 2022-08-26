extends Node2D

var frameCounter = 0
var selected = false
onready var rest_point = $Sprite.global_position
var frameStart = 1
var frameCounterMax = 4
var totalAnimationFrameCount = 16

func _on_ready():
	$Sprite.frame = frameStart
	totalAnimationFrameCount = int($txtColumns.text) * int($txtRows.text)
	$txtColumns.text = str($Sprite.vframes)
	$txtRows.text = str($Sprite.hframes)
	
	

func _on_AnimationTimer_timeout():
	if $txtImagesPerAnimation.text.is_valid_integer():
		frameCounterMax = int($txtImagesPerAnimation.text) 
		
	if frameCounter >= frameCounterMax + (frameStart - 1):
		frameCounter = frameStart - 1
		#print("Reset Sprite Frame To " + str(frameStart -1))
		
	$Sprite.frame = frameCounter
	#print("Sprite Frame: " + str($Sprite.frame))
	frameCounter += 1

func _on_DecreaseAnimationSpeed_pressed():
	$AnimationTimer.wait_time -= 0.05
	$Label.text = "Delay: " + str($AnimationTimer.wait_time)


func _on_IncreaseAnimationSpeed_pressed():
	$AnimationTimer.wait_time += 0.05
	$Label.text = "Delay: " + str($AnimationTimer.wait_time)


func _on_Button_pressed():
	$FileDialog.popup()


func _on_FileDialog_file_selected(path):
	var image = Image.new()
	image.load(path)
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	$Sprite.texture = texture
	$Preview.texture = texture
	$FileName.text = $FileDialog.current_file
			
func _physics_process(delta):
	if selected:
		$Sprite.global_position = lerp($Sprite.global_position, get_global_mouse_position(), 25 * delta)
#		look_at(get_global_mouse_position())
	else:
		$Sprite.global_position = lerp($Sprite.global_position, rest_point, 10 * delta)
#		rotation = lerp_angle(rotation, 0, 10 * delta)	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			rest_point = $Sprite.global_position


func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true
	if Input.is_action_just_pressed("rightclick"):
		$Sprite.scale.x += 0.25
		$Sprite.scale.y += 0.25
		#print($Sprite.scale.x);
		if($Sprite.scale.x >= 5):
			$Sprite.scale.x = 0.25
			$Sprite.scale.y = 0.25


func _on_txtColumns_text_changed():
	$AnimationTimer.stop()
	if $txtColumns.text.is_valid_integer():
		$Sprite.hframes = int($txtColumns.text)
		$AnimationTimer.start()

func _on_txtRows_text_changed():
	$AnimationTimer.stop()
	if $txtRows.text.is_valid_integer():
		$Sprite.vframes = int($txtRows.text)
		$AnimationTimer.start()

func _on_txtImagesPerAnimation_text_changed():
	pass # Replace with function body.

func _on_Button2_pressed():
	$AnimationTimer.stop()
	if $txtImagesPerAnimation.text.is_valid_integer():
		frameStart += int($txtImagesPerAnimation.text)
	if frameStart >= int($txtColumns.text) * int($txtRows.text):
		frameStart = 1
		
	$Sprite.frame = frameStart
	$lblAnimation.text = str(frameStart)
	$AnimationTimer.start()


func _on_PreviewArea_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("rightclick"):
		$Preview.scale.x += 0.5
		$Preview.scale.y += 0.5
		#print($Sprite.scale.x);
		if($Preview.scale.x >= 4):
			$Preview.scale.x = .5
			$Preview.scale.y = .5


func _on_Button3_pressed():
	if $Button3.text == "View Sheet":
		$Button3.text = "Hide Sheet"
		$Sprite.visible = false
		$Preview.visible = true
	else:
		$Button3.text = "View Sheet"
		$Preview.visible = false
		$Sprite.visible = true
	
