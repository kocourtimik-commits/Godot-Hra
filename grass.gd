extends AnimatedSprite2D

const SMER: float = -1.0
const DOBA_KLESANI: float = 5.0
const HLOUBKA: float = 300.0
const SIRKA_AREY: float = 17.0
const VYSKA_AREY: float = 9.0
const POSUN_AREY: float = -2.0

var stav: int = 0
var cas: float = 0.0
var start: Vector2

@onready var area_2d: Area2D = $Area2D
@onready var area_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var solid_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D


func _ready() -> void:
	priprav_area()
	area_2d.collision_layer = 0
	area_2d.collision_mask = 1
	area_2d.monitoring = true
	area_2d.monitorable = true
	if not area_2d.body_entered.is_connected(_on_area_2d_body_entered):
		area_2d.body_entered.connect(_on_area_2d_body_entered)


func priprav_area() -> void:
	area_2d.position = Vector2.ZERO
	area_2d.rotation = 0.0
	area_2d.scale = Vector2.ONE
	area_shape.position = Vector2(0.0, POSUN_AREY)
	area_shape.rotation = 0.0
	area_shape.scale = Vector2.ONE
	var tvar := RectangleShape2D.new()
	tvar.size = Vector2(SIRKA_AREY, VYSKA_AREY)
	area_shape.shape = tvar


func _process(delta: float) -> void:
	if stav == 0:
		return

	cas += delta
	var p := clampf(cas / DOBA_KLESANI, 0.0, 1.0)
	global_position = start + Vector2(0.0, SMER * HLOUBKA * p)

	if p >= 1.0:
		visible = false
		solid_shape.set_deferred("disabled", true)
		static_body.set_deferred("collision_layer", 0)
		set_process(false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if stav != 0:
		return
	if not body is CharacterBody2D:
		return

	start = global_position
	stav = 1
	cas = 0.0
