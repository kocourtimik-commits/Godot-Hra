extends Node2D

const RYCHLOST: float = 200.0
const ROZSAH: float = 600.0
const VYSKA_VLNY: float = 40.0
const TEXT_HLASKY: String = "try to build with milk"

var _start_x: float = 0.0
var _start_y: float = 0.0
var _cas: float = 0.0
var _smer: float = 1.0

var text: Label


func _ready() -> void:
	_start_x = position.x
	_start_y = position.y
	scale = Vector2(3.0, 3.0)
	z_index = 10

	text = Label.new()
	add_child(text)
	text.text = TEXT_HLASKY
	text.size = Vector2(240.0, 30.0)
	text.position = Vector2(-120.0, -90.0)
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.add_theme_font_size_override("font_size", 20)
	text.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	text.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0))
	text.add_theme_constant_override("outline_size", 6)


func _process(delta: float) -> void:
	_cas += delta
	position.x += _smer * RYCHLOST * delta
	if absf(position.x - _start_x) > ROZSAH:
		_smer = -_smer
	position.y = _start_y + sin(_cas * 2.0) * VYSKA_VLNY
	queue_redraw()


func _draw() -> void:
	var tmava := Color(0.18, 0.1, 0.25)
	var blana := Color(0.28, 0.16, 0.38)
	var mach := sin(_cas * 14.0)

	var levy := PackedVector2Array([
		Vector2(-8, -4),
		Vector2(-30, -22 + mach * 18.0),
		Vector2(-58, -8 + mach * 26.0),
		Vector2(-44, 4 + mach * 10.0),
		Vector2(-32, 10),
		Vector2(-20, 6),
		Vector2(-8, 8)
	])
	var pravy := PackedVector2Array()
	for bod in levy:
		pravy.append(Vector2(-bod.x, bod.y))

	draw_colored_polygon(levy, blana)
	draw_colored_polygon(pravy, blana)

	draw_circle(Vector2.ZERO, 12.0, tmava)
	draw_colored_polygon(PackedVector2Array([Vector2(-10, -8), Vector2(-7, -22), Vector2(-2, -10)]), tmava)
	draw_colored_polygon(PackedVector2Array([Vector2(10, -8), Vector2(7, -22), Vector2(2, -10)]), tmava)
	draw_circle(Vector2(-4.5, -2.0), 2.5, Color(1.0, 0.2, 0.2))
	draw_circle(Vector2(4.5, -2.0), 2.5, Color(1.0, 0.2, 0.2))
	draw_colored_polygon(PackedVector2Array([Vector2(-3, 5), Vector2(0, 10), Vector2(3, 5)]), Color(1.0, 1.0, 1.0))
