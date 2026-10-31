extends Sprite2D

@export var hrac: Node2D
@export var rychlost_dojezdu: float = 4.0

var cas: float = 0.0
var vyska_pohupu: float = 10.0
var rychlost_pohupu: float = 3.0

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D

func _ready() -> void:
	show_behind_parent = true
	if ray_cast:
		ray_cast.enabled = true
	
	if line_2d:
		line_2d.clear_points()
		line_2d.add_point(Vector2(0, 0))
		line_2d.add_point(Vector2(0, 150))

func _process(delta: float) -> void:
	if hrac:
		# 1. Pohyb a vznášení UFO
		cas += delta * rychlost_pohupu
		var pohup = Vector2(0, sin(cas) * vyska_pohupu)
		var cilova_pozice = hrac.global_position + Vector2(0, -70) + pohup
		
		global_position = global_position.lerp(cilova_pozice, rychlost_dojezdu * delta)
		
		# 2. Zastavení paprsku o bloky
		if ray_cast and line_2d:
			if ray_cast.is_colliding():
				var bod_narazu = ray_cast.get_collision_point()
				var lokalni_bod = line_2d.to_local(bod_narazu)
				
				if lokalni_bod.y > 10:
					if line_2d.get_point_count() > 1:
						line_2d.set_point_position(1, lokalni_bod)
			else:
				if line_2d.get_point_count() > 1:
					line_2d.set_point_position(1, Vector2(0, 150))
