# GodotTutorials

These are a few sample projects in Godot to help the community.

OpenChest
This simple project has a world, player, chest, and key scene.
The player has an area2d that stays in front of the players facing direction.
When the area2d collides with an object, it sets a local variable to the instance of the colliding body.
If the object is in a group called Key, then it increases a local variable chestKeys by 1 and destroys the object.

When the user presses a key, it checks if there is an object colliding with the area2d and what kind of object is colliding
if the object is a chest, and the user has a chestKeys > 0 then it will change the frame of the Chest's sprite. 
making it appear as if the chest has been opened.
If the players chestKeys is 0 or less, then we fake an animation using the rotation of the Chest's sprite
This is accomplished by setting rotation_degrees = -5, waiting 0.05 seconds then setting it to 5 then 0.05 seconds setting it back to 0.
This gives us a very basic feedback to notify the player they dont have a key to open the chest.

I have also added a label at the top of the world scene that updates with the players chestKeys value.
