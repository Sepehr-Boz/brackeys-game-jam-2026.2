class_name CharacterController2D
extends CharacterBody2D

@export var _walk_speed: float = 400
@export var _run_speed: float = 600

func get_move_input() -> void:
	# get input and set velocity
	var input_direction: Vector2 = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down").normalized()
	velocity = input_direction * (_run_speed if Input.is_action_pressed("sprint") else _walk_speed)

func _physics_process(delta) -> void:
	# move and apply physics
	get_move_input()
	move_and_slide()
