extends Line2D

@export var max_length: float = 300.0
@onready var ray_cast: RayCast2D = $"../RayCast2D"

func _ready() -> void:
	if ray_cast:
		ray_cast.enabled = true
		ray_cast.target_position = Vector2(0, max_length)

	clear_points()
	add_point(Vector2.ZERO)
	add_point(Vector2(0, max_length))
	
	width = 40.0
	default_color = Color(0.0, 1.0, 0.0, 1.0)

func _process(_delta: float) -> void:
	if ray_cast and ray_cast.is_colliding():
		var collision_point = ray_cast.get_collision_point()
		set_point_position(1, to_local(collision_point))
	else:
		set_point_position(1, Vector2(0, max_length))
