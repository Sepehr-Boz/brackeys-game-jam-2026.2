extends RichTextLabel

const STRING_FORMAT: String = "[p align=c][color=ffffffaa][b][font_size=192]%.1f[/font_size][/b][/color][/p]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.time_left.connect(_on_time_remaining_updated)

func _on_time_remaining_updated(time_remaining: float) -> void:
	text = STRING_FORMAT % clampf(time_remaining, 0.0, GameManager.LEVEL_TIME)
