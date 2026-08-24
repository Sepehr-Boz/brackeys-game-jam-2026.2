class_name NPCController2D
extends Area2D

@export var _walk_speed: float = 400
@export var _animations: Array[SpriteFrames] = []
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _vp: Rect2 = (get_viewport().get_camera_2d().get_canvas_transform().affine_inverse() * get_viewport().get_visible_rect())
@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _is_sprinting: bool = false
var velocity: Vector2

func _ready() -> void:
	# set a random spriteframe onto the sprite and play it
	_sprite.sprite_frames = _animations[_rng.randi_range(0, len(_animations) - 1)]
	_sprite.play()
	# on start spawn at random position (in screen) and move in random direction
	position = Vector2(
		_rng.randf_range(_vp.position.x, _vp.end.x),
		_rng.randf_range(_vp.position.y, _vp.end.y)
	)
	velocity = Vector2(
		_rng.randf_range(-1, 1),
		_rng.randf_range(-1, 1)
	).normalized() * _walk_speed

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
	position += velocity * delta
	# clamp the position so that the character is within the viewport at all times
	# once hit a wall then turn around
	if position.x <= _vp.position.x or position.x >= _vp.end.x:
		velocity.x = -velocity.x
	if position.y <= _vp.position.y or position.y >= _vp.end.y:
		velocity.y = -velocity.y
	position = Vector2(
		clampf(position.x, _vp.position.x, _vp.end.x),
		clampf(position.y, _vp.position.y, _vp.end.y)
	)
	set_animation()
