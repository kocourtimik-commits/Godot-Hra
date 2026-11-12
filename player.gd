extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED: float = 900.0
const JUMP_VELOCITY: float = 1100.0
const AIR_JUMP_VELOCITY: float = 950.0
const GRAVITACE: float = 1400.0
const MAX_SKOKU_VE_VZDUCHU: int = 2
const COYOTE: float = 0.12

var _cas_bez_zeme: float = 0.0
var _skoku_ve_vzduchu: int = 0
var _coyote: float = 0.0


func _ready() -> void:
	up_direction = Vector2(0, 1)
	motion_mode = MOTION_MODE_GROUNDED
	floor_snap_length = 0.0
	floor_stop_on_slope = false
	floor_constant_speed = true
	floor_block_on_wall = true
	floor_max_angle = deg_to_rad(60.0)
	slide_on_ceiling = false


func _physics_process(delta: float) -> void:
	if is_on_floor():
		_cas_bez_zeme = 0.0
		_coyote = COYOTE
		_skoku_ve_vzduchu = 0
	else:
		_cas_bez_zeme += delta
		_coyote = maxf(0.0, _coyote - delta)
		var nasobek := lerpf(1.0, 2.2, clampf(_cas_bez_zeme / 0.3, 0.0, 1.0))
		if velocity.y > -200.0:
			nasobek *= 0.6
		velocity.y -= GRAVITACE * nasobek * delta
		velocity.y = maxf(velocity.y, -1800.0)

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or _coyote > 0.0:
			velocity.y = JUMP_VELOCITY
			_coyote = 0.0
		elif _skoku_ve_vzduchu < MAX_SKOKU_VE_VZDUCHU:
			velocity.y = AIR_JUMP_VELOCITY
			_skoku_ve_vzduchu += 1

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
