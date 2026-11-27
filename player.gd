extends CharacterBody2D

@export var cooldown_dvojskoku: float = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var spodni_raycast: RayCast2D = $SpodniRayCast
@onready var horni_raycast: RayCast2D = $HorniRayCast
@export var sila_vylezu: float = 350

const SPEED: float = 900.0
const JUMP_VELOCITY: float = 1100.0
const AIR_JUMP_VELOCITY: float = 950.0
const GRAVITACE: float = 1400.0
const MAX_SKOKU_VE_VZDUCHU: int = 1
const COYOTE: float = 0.12

var mleko_scena = preload("res://mleko.tscn")

var _cas_bez_zeme: float = 0.0
var _skoku_ve_vzduchu: int = 0
var _coyote: float = 0.0
var _cooldown: float = 0.0


func _ready() -> void:
	up_direction = Vector2(0, 1)
	motion_mode = MOTION_MODE_GROUNDED
	floor_snap_length = 0.0
	floor_stop_on_slope = false
	floor_constant_speed = true
	floor_block_on_wall = true
	floor_max_angle = deg_to_rad(60.0)
	slide_on_ceiling = false
	set_collision_mask_value(2, true)


func _physics_process(delta: float) -> void:
	print("podlaha:", is_on_floor(), " spodni:", spodni_raycast.is_colliding(), " horni:", horni_raycast.is_colliding())
	_cooldown = maxf(0.0, _cooldown - delta)

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
		elif _skoku_ve_vzduchu < MAX_SKOKU_VE_VZDUCHU and _cooldown <= 0.0:
			velocity.y = AIR_JUMP_VELOCITY
			_skoku_ve_vzduchu += 1
			_cooldown = cooldown_dvojskoku
			vystrik_mleko()

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

	if direction:
		spodni_raycast.scale.x = direction 
		horni_raycast.scale.x = direction
		spodni_raycast.force_raycast_update()
		horni_raycast.force_raycast_update()

	if is_on_floor() and direction:
		if spodni_raycast.is_colliding() 	and not horni_raycast.is_colliding():
			velocity.y = sila_vylezu
	move_and_slide()


func vystrik_mleko() -> void:
	var mleko = mleko_scena.instantiate()
	get_parent().add_child(mleko)
	mleko.global_position = $MlekoPozice.global_position
	mleko.add_collision_exception_with(self)
	await get_tree().create_timer(0.3).timeout
	if is_instance_valid(mleko):
		mleko.remove_collision_exception_with(self)
		
		
