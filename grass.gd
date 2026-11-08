extends AnimatedSprite2D

@export_group("Třesení")
@export var shake_intenzita: float = 2.0 
@export var shake_zesilovani: bool = true   

@export_group("Pád")
@export var zpozdeni_pred_padem: float = 1.0
@export var hloubka_padu: float = 48.0
@export var doba_padu: float = 0.45

var has_fallen: bool = false
var hrac_na_bloku: bool = false
var cas_na_bloku: float = 0.0
var zakladni_offset: Vector2

@onready var area_2d: Area2D = $Area2D
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var solid_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	zakladni_offset = offset
	area_2d.collision_layer = 0
	area_2d.collision_mask = 1
	area_2d.monitoring = true
	if not area_2d.body_entered.is_connected(_on_area_2d_body_entered):
		area_2d.body_entered.connect(_on_area_2d_body_entered)
	if not area_2d.body_exited.is_connected(_on_area_2d_body_exited):
		area_2d.body_exited.connect(_on_area_2d_body_exited)


func _process(delta: float) -> void:
	if has_fallen or not hrac_na_bloku:
		return

	cas_na_bloku += delta

	var pomer := clampf(cas_na_bloku / zpozdeni_pred_padem, 0.0, 1.0)
	var intenzita := shake_intenzita
	if shake_zesilovani:
		intenzita *= lerpf(0.4, 1.0, pomer)

	offset = zakladni_offset + Vector2(
		randf_range(-intenzita, intenzita),
		randf_range(-intenzita, intenzita)
	)

	if cas_na_bloku >= zpozdeni_pred_padem:
		_propadni_se()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if has_fallen or not body is CharacterBody2D:
		return
	hrac_na_bloku = true
	print("Hráč vstoupil na blok: ", body.name)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if has_fallen or not body is CharacterBody2D:
		return
	hrac_na_bloku = false
	cas_na_bloku = 0.0
	offset = zakladni_offset


func _propadni_se() -> void:
	has_fallen = true
	offset = zakladni_offset

	# vypni pevnou kolizi, aby hráč propadl
	solid_shape.set_deferred("disabled", true)
	static_body.set_deferred("collision_layer", 0)

	var pad := create_tween().set_parallel(true)
	pad.tween_property(self, "global_position:y", global_position.y + hloubka_padu, doba_padu) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	pad.tween_property(self, "modulate:a", 0.0, doba_padu)
	await pad.finished

	visible = false
