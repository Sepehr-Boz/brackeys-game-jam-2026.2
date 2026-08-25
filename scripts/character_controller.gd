class_name CharacterController2D
extends Area2D

@export var _walk_speed: float = 400
@export var _run_speed: float = 600
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _vp: Rect2 = (get_viewport().get_camera_2d().get_canvas_transform().affine_inverse() * get_viewport().get_visible_rect())
var _is_sprinting: bool = false
var velocity: Vector2
var _can_control: bool = true

func _ready() -> void:
	GameManager.instance.player_hit.connect(_lost_level)
	GameManager.instance.player_safe.connect(_won_level)
	
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
	if not _can_control:
		return
	get_move_input()
	position += velocity * delta
	# clamp the position so that the character is within the viewport at all times
	position = Vector2(
		clampf(position.x, _vp.position.x, _vp.end.x),
		clampf(position.y, _vp.position.y, _vp.end.y)
	)
	set_animation()

func _lost_level() -> void:
	velocity = Vector2.ZERO
	_can_control = false
	_sprite.animation = "hit"

func _won_level() -> void:
	velocity = Vector2.ZERO
	_can_control = false
	_sprite.animation = "victory"
