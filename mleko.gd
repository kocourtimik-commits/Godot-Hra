extends CharacterBody2D

const GRAVITACE: float = 1400.0
const DOBA_ZIVOTA: float = 5.0
const TRENI: float = 600.0


func _ready() -> void:
	up_direction = Vector2(0, 1)
	motion_mode = MOTION_MODE_GROUNDED
	collision_layer = 2
	collision_mask = 3

	position.x += randf_range(-20.0, 20.0)
	velocity = Vector2(randf_range(-150.0, 150.0), 200.0)

	await get_tree().create_timer(DOBA_ZIVOTA).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, TRENI * delta)
	else:
		velocity.y -= GRAVITACE * delta

	move_and_slide()
