extends Control

@export var pozadi_obrazek: Texture2D
@export var logo_obrazek: Texture2D
@export var postava_obrazek: Texture2D
@export var tlacitko_obrazek: Texture2D
@export var nazev_hry: String = "KRAVA"
@export var barva_pozadi: Color = Color(0.05, 0.09, 0.16)
@export_file("*.tscn") var hra_scena: String = "res://node_2d.tscn"

var _tlacitko: Button
var _odchazim: bool = false


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var barva := ColorRect.new()
	barva.color = barva_pozadi
	add_child(barva)
	barva.set_anchors_preset(Control.PRESET_FULL_RECT)

	if pozadi_obrazek:
		var pozadi := TextureRect.new()
		pozadi.texture = pozadi_obrazek
		pozadi.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pozadi.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		add_child(pozadi)
		pozadi.set_anchors_preset(Control.PRESET_FULL_RECT)

		var stin := ColorRect.new()
		stin.color = Color(0.0, 0.0, 0.0, 0.35)
		add_child(stin)
		stin.set_anchors_preset(Control.PRESET_FULL_RECT)

	var stred := CenterContainer.new()
	add_child(stred)
	stred.set_anchors_preset(Control.PRESET_FULL_RECT)

	var sloupec := VBoxContainer.new()
	sloupec.alignment = BoxContainer.ALIGNMENT_CENTER
	sloupec.add_theme_constant_override("separation", 40)
	stred.add_child(sloupec)

	if logo_obrazek:
		var logo := TextureRect.new()
		logo.texture = logo_obrazek
		logo.custom_minimum_size = Vector2(700.0, 220.0)
		logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		sloupec.add_child(logo)
	else:
		var nazev := Label.new()
		nazev.text = nazev_hry
		nazev.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nazev.add_theme_font_size_override("font_size", 120)
		nazev.add_theme_color_override("font_color", Color(1.0, 0.97, 0.85))
		nazev.add_theme_color_override("font_outline_color", Color(0.1, 0.05, 0.0))
		nazev.add_theme_constant_override("outline_size", 24)
		nazev.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.6))
		nazev.add_theme_constant_override("shadow_offset_x", 6)
		nazev.add_theme_constant_override("shadow_offset_y", 6)
		sloupec.add_child(nazev)

	if postava_obrazek:
		var postava := TextureRect.new()
		postava.texture = postava_obrazek
		postava.custom_minimum_size = Vector2(320.0, 320.0)
		postava.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		postava.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		postava.pivot_offset = postava.custom_minimum_size / 2.0
		sloupec.add_child(postava)

		var houpani := create_tween().set_loops()
		houpani.tween_property(postava, "rotation_degrees", 4.0, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		houpani.tween_property(postava, "rotation_degrees", -4.0, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	_tlacitko = Button.new()
	_tlacitko.text = "PLAY"
	_tlacitko.custom_minimum_size = Vector2(380.0, 120.0)
	_tlacitko.pivot_offset = _tlacitko.custom_minimum_size / 2.0
	_tlacitko.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_tlacitko.focus_mode = Control.FOCUS_ALL
	_tlacitko.add_theme_font_size_override("font_size", 56)
	_tlacitko.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	_tlacitko.add_theme_color_override("font_hover_color", Color(1.0, 0.95, 0.5))
	_tlacitko.add_theme_color_override("font_pressed_color", Color(1.0, 0.85, 0.3))
	_tlacitko.add_theme_color_override("font_focus_color", Color(1.0, 0.95, 0.5))
	_tlacitko.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0))
	_tlacitko.add_theme_constant_override("outline_size", 8)
	_tlacitko.add_theme_stylebox_override("normal", _styl(Color(0.25, 0.6, 0.2), Color(0.1, 0.3, 0.1)))
	_tlacitko.add_theme_stylebox_override("hover", _styl(Color(0.33, 0.72, 0.27), Color(1.0, 0.95, 0.5)))
	_tlacitko.add_theme_stylebox_override("pressed", _styl(Color(0.18, 0.45, 0.15), Color(0.1, 0.3, 0.1)))
	_tlacitko.add_theme_stylebox_override("focus", _styl(Color(0.33, 0.72, 0.27), Color(1.0, 0.95, 0.5)))
	_tlacitko.pressed.connect(_on_play_pressed)
	_tlacitko.mouse_entered.connect(_zvetsit.bind(true))
	_tlacitko.mouse_exited.connect(_zvetsit.bind(false))
	sloupec.add_child(_tlacitko)
	_tlacitko.grab_focus()

	modulate.a = 0.0
	create_tween().tween_property(self, "modulate:a", 1.0, 0.6)


func _styl(barva: Color, ohraniceni: Color) -> StyleBox:
	if tlacitko_obrazek:
		var tex := StyleBoxTexture.new()
		tex.texture = tlacitko_obrazek
		return tex
	var styl := StyleBoxFlat.new()
	styl.bg_color = barva
	styl.border_color = ohraniceni
	styl.set_border_width_all(6)
	styl.set_corner_radius_all(28)
	styl.shadow_color = Color(0.0, 0.0, 0.0, 0.5)
	styl.shadow_size = 10
	styl.shadow_offset = Vector2(0.0, 6.0)
	return styl


func _zvetsit(zvetsit: bool) -> void:
	var cil := Vector2(1.08, 1.08) if zvetsit else Vector2.ONE
	create_tween().tween_property(_tlacitko, "scale", cil, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_play_pressed() -> void:
	if _odchazim:
		return
	_odchazim = true
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	await tween.finished
	get_tree().change_scene_to_file(hra_scena)
