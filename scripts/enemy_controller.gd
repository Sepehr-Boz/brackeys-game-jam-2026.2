class_name EnemyController2D
extends NPCController2D

var _bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	# connect to the time up signal in game manager and when it emits then
	# make the enemy face towards the player and shoot
	GameManager.time_up.connect(_on_timer_up)
	GameManager.player_hit.connect(_on_player_hit)

func _on_timer_up() -> void:
	velocity = Vector2.ZERO
	_sprite.animation = "idle"
	_sprite.flip_h = GameManager.player.position.x < position.x
	var bullet: Bullet2D = _bullet_scene.instantiate()
	add_sibling(bullet)
	bullet.shoot(position, GameManager.player.position)

func _on_player_hit() -> void:
	velocity = Vector2.ZERO
	_sprite.animation = "victory"
	_sprite.flip_h = _rng.randi_range(0, 1) == 1
