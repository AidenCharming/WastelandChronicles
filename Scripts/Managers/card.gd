extends Sprite2D

@export var card_name: String
@export var card_type: String
@export var attributes: Dictionary = {}

func _ready():
	update_card_data()

func update_card_data():
	$NameLabel.text = card_name

	var portrait_sprite = $SurvivorPortrait
