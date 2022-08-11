extends Node2D

func _process(delta):
	#All we are doing here is looking at the Player nodes exported variable
	#chestKeys to be able to get a count of how many keys the player has.
	#the str() function converts the integer to a String
	$Label.text = "Keys: " + str($Player.chestKeys)


