extends Node

@export var spawn_point: Node2D
@export var player_normal: CharacterBody2D
@export var player_hflat: CharacterBody2D

var current_player: CharacterBody2D = null

const OFF_SCREEN_POSITION = Vector2(-200, -200)


func _ready() -> void:
	current_player = player_normal
	_swap_in(current_player, spawn_point.position)


func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_P:
		_swap()


func _swap():
	var current_position = current_player.position
	_swap_out(current_player)
	if current_player == player_normal:
		current_player = player_hflat
	else:
		current_player = player_normal
	_swap_in(current_player, current_position)



func _swap_in(p: CharacterBody2D, position: Vector2):
	p.position = position
	p.set_script(preload("res://scripts/player.gd"))
	if p == player_hflat:
		p.jump_height = 300
	p.splat.connect(_on_splat)
	p.unsplat.connect(_on_unsplat)
	p.set_physics_process(true)


func _swap_out(p: CharacterBody2D):
	p.position = OFF_SCREEN_POSITION
	p.set_physics_process(false)
	p.set_script(null)


func _on_splat():
	if current_player == player_normal:
		_swap()


func _on_unsplat():
	if current_player == player_hflat:
		_swap()
