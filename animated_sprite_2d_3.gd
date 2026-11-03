extends AnimatedSprite2D

@export var min_cas_behu: float = 2.0
@export var max_cas_behu: float = 15.0
@export var min_cas_stani: float = 2.0
@export var max_cas_stani: float = 15.0
@export var nazev_animace: String = "default"

var casovac: float = 0.0
var cilovy_cas: float = 0.0
var bezi: bool = false

func _ready() -> void:
	randomize()
	spustit_stani()

func _process(delta: float) -> void:
	casovac += delta
	
	if casovac >= cilovy_cas:
		if bezi:
			spustit_stani()
		else:
			spustit_beh()

func spustit_beh() -> void:
	bezi = true
	casovac = 0.0
	cilovy_cas = randf_range(min_cas_behu, max_cas_behu)
	play(nazev_animace)

func spustit_stani() -> void:
	bezi = false
	casovac = 0.0
	cilovy_cas = randf_range(min_cas_stani, max_cas_stani)
	stop()
