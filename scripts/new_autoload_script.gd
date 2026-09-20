extends Node

var current_level = 1
var levels_completed = 1


func load_level(idx):
	current_level = idx
	get_tree().change_scene_to_file("res://scenes/level_%d.tscn" % idx)


func next_level():
	current_level += 1

	if current_level == 3:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return

	levels_completed = max(levels_completed, current_level)
	load_level(current_level)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
