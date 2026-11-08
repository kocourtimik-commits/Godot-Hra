extends StaticBody2D

# Sleduje, jestli už plošina spadla, aby se animace nespustila znovu
var has_fallen: bool = false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	# Připojení signálu z Area2D kódově (pokud ho nepropojuješ přes editor)
	if not area_2d.body_entered.is_connected(_on_area_2d_body_entered):
		area_2d.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Zkontrolujeme, jestli na plošinu stoupnul hráč (CharacterBody2D)
	if body is CharacterBody2D and not has_fallen:
		has_fallen = true
		
		# Vytvoříme tweeny pro plynulý pád a mizení
		var tween_pos = create_tween().set_trans(Tween.TRANS_SINE)
		var tween_fade = create_tween().set_trans(Tween.TRANS_SINE)
		
		# Posuneme plošinu o 12 pixelů dolů za 0.5 sekundy
		tween_pos.tween_property(self, "global_position", global_position + Vector2(0, 12), 0.5)
		
		# Zprůhledníme plošinu (opacity na 0) za 0.5 sekundy
		tween_fade.tween_property(self, "modulate:a", 0.0, 0.5)
		
		# Až tween skončí, vypneme kolizi, aby hráč propadl
		tween_pos.finished.connect(_disable_collider)

func _disable_collider() -> void:
	collision_shape_2d.disabled = true
