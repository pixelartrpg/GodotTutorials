extends Node

# Traverse the node tree and replace Tiled objects
func post_import(scene):
	# Load scenes to instantiate and add to the level
	var Tree = load("res://Object Templates/Tree.tscn")
	var Bush = load("res://Object Templates/Bush.tscn")
	# The scene variable contains the nodes as you see them in the editor.
	# scene itself points to the top node. Its children are the tile and object layers.
	for node in scene.get_children():
		# To know the type of a node, check if it is an instance of a base class
		# The addon imports tile layers as TileMap nodes and object layers as Node2D
		if node is TileMap:
			# Process tile layers. E.g. read the ID of the individual tiles and
			# replace them with random variations, or instantiate scenes on top of them
			pass
		elif node is Node2D:
			for object in node.get_children():
				# Assume all objects have a custom property named "type" and get its value
				var type = object.get_meta("type")
				var node_to_clone = null
				if type == "tree":
					node_to_clone = Tree
				if type == "bush":
					node_to_clone = Bush
				if node_to_clone:
					var new_instance = node_to_clone.instance()
					#we adjust the positioning of the object to properly align in godot
					#the 25,-10 may vary based on your map/tiles. But it will be consistent across
					#the map for all tiles.
					new_instance.position = object.position + Vector2(25, -10)
					
					scene.add_child(new_instance)
					new_instance.set_owner(scene)
			# After you processed all the objects, remove the object layer
			node.free()
	# You must return the modified scene
	return scene
