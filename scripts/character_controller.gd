class_name CharacterController2D
extends CharacterBody2D

@export var _walk_speed: float = 400
@export var _run_speed: float = 600
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _vp: Rect2 = (get_viewport().get_camera_2d().get_canvas_transform().affine_inverse() * get_viewport().get_visible_rect())
var _is_sprinting: bool = false

func _ready() -> void:
	_sprite.play()

func get_move_input() -> void:
	# get input and set velocity
	var input_direction: Vector2 = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down").normalized()
	_is_sprinting = Input.is_action_pressed("sprint")
	velocity = input_direction * (_run_speed if _is_sprinting else _walk_speed)

func set_animation() -> void:
	if velocity == Vector2.ZERO:
		_sprite.animation = "idle"
	else:
		if _is_sprinting:
			_sprite.animation = "sprint"
		else:
			_sprite.animation = "walk"
		# only flip on when actually turned
		if velocity.x < 0:
			_sprite.flip_h = true
		elif velocity.x > 0:
			_sprite.flip_h = false

func _process(delta: float) -> void:
	# clamp the position so that the character is within the viewport at all times
	position = Vector2(
		clampf(position.x, _vp.position.x, _vp.end.x),
		clampf(position.y, _vp.position.y, _vp.end.y)
	)

func _physics_process(delta) -> void:
	# move and apply physics
	get_move_input()
	move_and_slide()
	set_animation()
