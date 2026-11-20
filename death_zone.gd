extends Area2D

@export_file("*.tscn") var dalsi_level: String = "res://level2.tscn"


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file", dalsi_level)
