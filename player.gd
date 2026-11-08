extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 900.0
const JUMP_VELOCITY = 1100.0      # kladné = dolů na obrazovce = od podlahy pryč

@export_group("Diagnostika")
@export var diag: bool = true

@export_group("Obrácený platformer")
@export var up_smer: Vector2 = Vector2(0, 1)   # podlaha je NAD hráčem
@export var prilehani: float = 30.0            # floor_snap_length

@export_group("Auto přejití schodu")
@export var auto_step_enabled: bool = true
@export var step_height: float = 24.0
@export var step_probe: float = 12.0
@export var step_cooldown: float = 0.15

var _cooldown: float = 0.0
var _posledni_diag: String = ""


func _ready() -> void:
	up_direction = up_smer
	motion_mode = MOTION_MODE_GROUNDED
	floor_snap_length = prilehani
	floor_stop_on_slope = true
	floor_max_angle = deg_to_rad(45.0)

	if diag:
		print("=========== START DIAGNOSTIKY ===========")
		print("[DIAG] up_direction      = ", up_direction)
		print("[DIAG] motion_mode       = ", motion_mode)
		print("[DIAG] floor_snap_length = ", floor_snap_length)
		print("[DIAG] collision_layer   = ", collision_layer)
		print("[DIAG] collision_mask    = ", collision_mask)
		print("[DIAG] gravity          = ", get_gravity())
		var tvar := $CollisionShape2D.shape
		if tvar is RectangleShape2D:
			print("[DIAG] moje kolize       = ", tvar.size)
		elif tvar is CapsuleShape2D:
			print("[DIAG] moje kolize       = capsule r=", tvar.radius, " h=", tvar.height)
		else:
			print("[DIAG] moje kolize       = ", tvar)
		print("=========================================")


func _physics_process(delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	if not is_on_floor():
		velocity.y -= 980.0 * delta     # tvoje dvojitá gravitace – nechávám ji

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

	if auto_step_enabled and direction != 0.0 and _cooldown <= 0.0:
		_zkus_prekrocit(direction)

	move_and_slide()

	if diag and direction != 0.0:
		_vypis_stav(direction)


# ---------- AUTO PŘEJITÍ ----------
func _zkus_prekrocit(direction: float) -> void:
	if not is_on_floor():
		if diag: print("[DIAG] SKIP: nejsem na zemi (is_on_floor = false)")
		return

	var dopredu := Vector2(direction * step_probe, 0.0)
	if not test_move(global_transform, dopredu):
		return   # nic v cestě – normální chůze

	# v obráceném světě se schod obchází DOLŮ na obrazovce (+Y)
	var svisle := Vector2(0.0, step_height + 4.0)

	if test_move(global_transform, svisle):
		if diag: print("[DIAG] FAIL 1: nemám se kam posunout, test_move(", svisle, ") = true")
		return

	var po_posunu := global_transform.translated(svisle)
	if test_move(po_posunu, Vector2(direction * (step_probe + 8.0), 0.0)):
		if diag: print("[DIAG] FAIL 2: je to zeď, ne schod (po posunu je cesta zablokovaná)")
		return

	var pozice_pred := global_position
	global_position += svisle
	velocity = Vector2.ZERO
	apply_floor_snap()
	_cooldown = step_cooldown

	if diag:
		print("[DIAG] OK: přešel jsem schod o ", svisle.y, " px (", pozice_pred, " -> ", global_position, ")")


# ---------- VÝPIS STAVU ----------
func _vypis_stav(direction: float) -> void:
	var dopredu := Vector2(direction * step_probe, 0.0)
	var prekazka := test_move(global_transform, dopredu)
	var svisle := Vector2(0.0, step_height + 4.0)
	var volno_svisle := not test_move(global_transform, svisle)
	var po_posunu_volno := not test_move(global_transform.translated(svisle),
		Vector2(direction * (step_probe + 8.0), 0.0))

	var stav := "na_zemi=%s | prekazka_vpredu=%s | misto_posunu=%s | po_posunu_volno=%s | y=%d" % [
		is_on_floor(), prekazka, volno_svisle, po_posunu_volno, int(global_position.y)
	]
	if stav != _posledni_diag:
		_posledni_diag = stav
		print("[DIAG] ", stav)
