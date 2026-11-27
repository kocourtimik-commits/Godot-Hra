extends Sprite2D

@export var hrac: Node2D
@export var rychlost_dojezdu: float = 5.0

var cas: float = 0.0
var vyska_pohupu: float = 10.0
var rychlost_pohupu: float = 3.0

@onready var ray_cast: RayCast2D = $RayCast2D

func _ready() -> void:
	show_behind_parent = true
	if ray_cast:
		ray_cast.enabled = true

func _process(delta: float) -> void:
	if hrac:
		cas += delta * rychlost_pohupu
		var pohup_x = sin(cas * 0.7) * 50.0
		var pohup_y = sin(cas) * vyska_pohupu
		
		var cilova_pozice = Vector2(hrac.global_position.x + pohup_x, hrac.global_position.y - 355.0 + pohup_y)
		global_position = global_position.lerp(cilova_pozice, rychlost_dojezdu * delta)
		 
