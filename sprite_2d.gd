extends Sprite2D

@export var hrac: Node2D
@export var rychlost_dojezdu: float = 5

var cas: float = 0.0
var vyska_pohupu: float = 100.0
var rychlost_pohupu: float = 3.0

func _ready() -> void:
	show_behind_parent = true
	
func _process(delta: float) -> void:
	if hrac:
		cas += delta * rychlost_pohupu
		var pohup = Vector2(0, sin(cas) * vyska_pohupu)
		
		var cilova_pozice = Vector2(hrac.global_position.x - 50.0, hrac.global_position.y - 70.0) + pohup
		
		global_position = global_position.lerp(cilova_pozice, rychlost_dojezdu * delta)
