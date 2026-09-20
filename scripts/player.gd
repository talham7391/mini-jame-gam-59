class_name Player
extends CharacterBody2D

@export var jump_height: float = 550
@export var speed: float = 200.0
@export var player_controller: Node

enum STATE {
	IDLE,
	WALKING,
	FALLING,
}

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_flying = false
var scale_direction = 1
var current_state = STATE.IDLE
var splatted = false

signal splat
signal unsplat


func fly():
	is_flying = true
	await get_tree().create_timer(0.4).timeout
	is_flying = false


func init() -> void:
	var success = get_node("../success")
	success.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body != self:
		return
	GameState.next_level()


func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("player_left", "player_right")
	if is_flying:
		velocity.x = -900
	else:
		velocity.x = direction * 200
	
	if Input.is_action_just_pressed("player_left") and scale_direction == 1:
		scale.x = -1
		scale_direction = -1
	if Input.is_action_just_pressed("player_right") and scale_direction == -1:
		scale.x = -1
		scale_direction = 1
	
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
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
	
	if change_in_velocity.y > 850:
		splat.emit()
	
	if abs(change_in_velocity.x) > 850:
		unsplat.emit()
	
	current_state = STATE.IDLE
	
	if abs(change_in_position.x) > 0 and is_on_floor():
		current_state = STATE.WALKING

	if change_in_position.y < -8 and !is_on_floor():
		current_state = STATE.FALLING
	
	if not splatted:
		if current_state == STATE.IDLE:
			$idle_animation.visible = true
			$walking_animation.visible = false
			$falling_animation.visible = false
		elif current_state == STATE.WALKING:
			$idle_animation.visible = false
			$walking_animation.visible = true
			$falling_animation.visible = false
		elif current_state == STATE.FALLING:
			$idle_animation.visible = false
			$walking_animation.visible = false
			$falling_animation.visible = true


func start_splat():
	splatted = true
	$idle_animation.visible = false
	$walking_animation.visible = false
	$falling_animation.visible = false
	$splat_animation.animation_finished.connect(_stop_splat)
	$splat_animation.frame = 0
	$splat_animation.visible = true
	$splat_animation.play()


func _stop_splat():
	$splat_animation.visible = false
	$idle_animation.visible = true
	splatted = false
