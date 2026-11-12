extends AnimatedSprite2D

const SMER: float = -1.0
const DOBA_PADU: float = 5.0
const VZDALENOST: float = 900.0

var stav: int = 0
var cas: float = 0.0
var start_pad: Vector2

@onready var area_2d: Area2D = $Area2D
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var solid_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D


func _ready() -> void:
	area_2d.collision_layer = 0
	area_2d.collision_mask = 1
	area_2d.monitoring = true
	if not area_2d.body_entered.is_connected(_on_area_2d_body_entered):
		area_2d.body_entered.connect(_on_area_2d_body_entered)


func _process(delta: float) -> void:
	if stav == 0:
		return

	cas += delta
	var p := clampf(cas / DOBA_PADU, 0.0, 1.0)
	global_position = start_pad + Vector2(0.0, SMER * VZDALENOST * p)
	if p > 0.8:
		modulate.a = clampf(1.0 - (p - 0.8) / 0.2, 0.0, 1.0)
	if p >= 1.0:
		visible = false
		set_process(false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if stav != 0:
		return
	if not body is CharacterBody2D:
		return
	start_pad = global_position
	stav = 1
	cas = 0.0
	solid_shape.set_deferred("disabled", true)
	static_body.set_deferred("collision_layer", 0)
	area_2d.set_deferred("monitoring", false)
