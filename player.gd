extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 900.0
const JUMP_VELOCITY = 1100.0


func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta



	if not is_on_floor():
		velocity.y -= 980.0 * delta 

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.play("run")
		animated_sprite.flip_h = direction < 0
		animated_sprite.scale = Vector2(1.0, 1.0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")
		animated_sprite.scale = Vector2(0.1, 0.1)
		animated_sprite.position.y = -20
	move_and_slide()
