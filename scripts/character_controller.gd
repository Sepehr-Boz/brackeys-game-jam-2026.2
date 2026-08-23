class_name CharacterController2D
extends CharacterBody2D

@export var _move_speed = 400

func get_input():
	var input_direction = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down").normalized()
	velocity = input_direction * _move_speed

func _physics_process(delta):
	get_input()
	move_and_slide()
