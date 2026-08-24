extends Node
# THIS IS A SINGLETON SCRIPT THAT WILL BE ACCESSED THROUGH GameManager

const NPC_TO_ENEMY_RATIO: int = 4 # 4 npcs for every 1 enemy spawned
const LEVEL_TIME: float = 10.0 # duration (seconds) for each level before the end

signal time_left(time_remaining: float) # how much time is left
signal time_up() # when the time for the level finished
signal player_hit() # when the player has been hit at the end of the level
signal player_safe() # when the player has not been hit at the end of the level
signal level_started() # when the level has been started

var _player_scene: PackedScene = preload("res://scenes/player.tscn")
var _npc_scene: PackedScene = preload("res://scenes/npc.tscn")
var _enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

var _level_num: int = 1
static var player: CharacterController2D
var _npcs: Array[NPCController2D] = []
var _enemies: Array[EnemyController2D] = []
var _time_remaining: float = LEVEL_TIME
var _waiting_for_player_check: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect the needed signals to know when to increment the level
	player_safe.connect(_increment_level)
	player_hit.connect(_load_game_over)
	# on start spawn in the player and the initial number of enemies
	player = _player_scene.instantiate()
	add_child(player)
	_load_level()

func _process(delta: float) -> void:
	if _time_remaining <= 0:
		if not _waiting_for_player_check:
			time_up.emit()
			_waiting_for_player_check = true
		return
	_time_remaining -= delta
	time_left.emit(_time_remaining)


func _unload_npcs() -> void:
	for npc: NPCController2D in _npcs:
		npc.free()
	for enemy: EnemyController2D in _enemies:
		enemy.free()
	_npcs.clear()
	_enemies.clear()

func _load_level() -> void:
	for i in _level_num:
		# spawn 1 enemy and ratio n npcs
		var enemy: EnemyController2D = _enemy_scene.instantiate()
		add_child(enemy)
		_enemies.append(enemy)
		for j in NPC_TO_ENEMY_RATIO:
			var npc: NPCController2D = _npc_scene.instantiate()
			add_child(npc)
			_npcs.append(npc)
	level_started.emit()
	_time_remaining = LEVEL_TIME
	time_left.emit(_time_remaining)

func _increment_level() -> void:
	_level_num += 1
	_unload_npcs()
	_load_level()
	_waiting_for_player_check = false

func _load_game_over() -> void:
	print("game lose")
	# TODO: open a game over menu that will allow the player to restart
