extends StaticBody2D

#Exporting variables so we have access to them from the player script.
export var isOpened = false
export var contains = "Coins"

func _ready():
	#We are creating a texture and an image, then loading the image with the correct file from our Resources
	var texture = ImageTexture.new()
	var image = Image.new()
	#By default the contains variable is Coins, as you see above. However, when adding chests to the world scene
	#you will see in the inspector, you can change the contains value. Putting in Armor will trigger the other If
	if contains == "Coins":
		#loading up the coin image from resources
		image.load("res://Resources/Artwork/Objects/coin.png")
		#Contents is a Particle2D (particle effect)
		#We set the emission shape to 1, Sphere. See below for EmissionShape Enum
		$Contents.process_material.set_emission_shape(1)
		#We set the scale of the coin. We want them tiny so the scale is reasonable to the character etc.
		$Contents.process_material.scale = 0.3 
		#This sets how many coins we want to draw out
		$Contents.amount = 8
		#This sets how long the particle effect should run. Lower number is shorter, higher is longer.
		$Contents.lifetime = 0.8
		#this sets how fast the particle animation happens.
		$Contents.speed_scale = 2
	if contains == "Armor":
		image.load("res://Resources/Artwork/Objects/armor.png")
		#Here we set the emission shape to point.
		$Contents.process_material.set_emission_shape(0)
		#Since we are doing only a single image, we make it bigger than coins. But not full size.
		$Contents.process_material.scale = 0.5
		#We only want to draw one armor image.
		$Contents.amount = 1
		#We have slowed down the speed so we make it last longer
		$Contents.lifetime = 2
		#We want the armor to slowly rise, give the user a chance to see it.
		$Contents.speed_scale = 0.75
	#Here we set the texture to the image we loaded above	
	texture.create_from_image(image)
	#Then set the Particle2D's texture to the above
	$Contents.texture = texture



#Emission Shapes Enum - Built In
#EMISSION_SHAPE_POINT = 0
	#All particles will be emitted from a single point.
#EMISSION_SHAPE_SPHERE = 1
	#Particles will be emitted in the volume of a sphere.
#EMISSION_SHAPE_BOX = 2
	#Particles will be emitted in the volume of a box.
#EMISSION_SHAPE_POINTS = 3
	#Particles will be emitted at a position determined by sampling a random point on the emission_point_texture.
	#Particle color will be modulated by emission_color_texture.
#EMISSION_SHAPE_DIRECTED_POINTS = 4
	#Particles will be emitted at a position determined by sampling a random point on the emission_point_texture.
	#Particle velocity and rotation will be set based on emission_normal_texture.
	#Particle color will be modulated by emission_color_texture.
#EMISSION_SHAPE_RING = 5
	#Particles will be emitted in a ring or cylinder.
#EMISSION_SHAPE_MAX = 6
	#Represents the size of the EmissionShape enum.
