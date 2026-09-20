class_name Player
extends CharacterBody2D

@export var jump_height: float = 400
@export var speed: float = 200.0
@export var player_controller: Node

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_flying = false

signal splat
signal unsplat


func fly():
	is_flying = true
	await get_tree().create_timer(0.2).timeout
	is_flying = false


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("player_left", "player_right")
	if is_flying:
		velocity.x = -650
	else:
		velocity.x = direction * 100
	
	if Input.is_action_just_pressed("player_jump"):
		velocity.y = jump_height * -1
	else:
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("player_fall_through"):
		set_collision_mask_value(2, false)
	
	if Input.is_action_just_released("player_fall_through"):
		set_collision_mask_value(2, true)
	
	var prev_velocity = velocity
	var prev_position = position
	
	move_and_slide()

	var change_in_velocity = prev_velocity - velocity
	var change_in_position = prev_position - position
	
	if change_in_velocity.y > 600:
		splat.emit()
	
	if abs(change_in_velocity.x) > 600:
		unsplat.emit()
