extends Node2D

func _ready() -> void:
	spawn_test_cards()

func spawn_test_cards() -> void:
	# Load the card scene
	var card_scene: PackedScene = preload("res://Scenes/Cards/Card.tscn")
	
	# Create and add test cards to the scene
	if card_scene:
		var card1 = card_scene.instantiate()
		card1.set("card_name", "Survivor 1")
		card1.set("card_type", "Survivor")
		card1.set("attributes", {"Strength": 5, "Agility": 3, "Intelligence": 2})
		card1.position = Vector2(200, 200)
		add_child(card1)
