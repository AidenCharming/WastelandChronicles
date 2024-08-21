extends Sprite2D

@export var card_name: String
@export var card_type: String
@export var attributes: Dictionary = {}

func _ready():
	update_card_data()

func update_card_data():
	$NameLabel.text = card_name

	var portrait_sprite = $SurvivorPortrait
	if portrait_sprite != null:
		# Update the portrait based on attributes or card type if needed
		# Example: portrait_sprite.texture = some_texture_based_on_card_type
	else:
		print("SurvivorPortrait node not found")
