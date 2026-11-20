extends Node2D

@export var sirka: float = 400.0
@export var vyska: float = 200.0


func _ready() -> void:
	var obrazek := get_node_or_null("Sprite2D")
	if obrazek:
		obrazek.region_enabled = true
		obrazek.region_rect = Rect2(0.0, 0.0, sirka, vyska)
		obrazek.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
