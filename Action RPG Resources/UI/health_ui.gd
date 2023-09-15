extends Control

@onready var fullHeartsUI = $FullHeartUI
@onready var emptyHeartsUI = $EmptyHeartUI

var max_hearts = 4:
	set = set_max_hearts

var hearts = 4: set = set_hearts
# Called when the node enters the scene tree for the first time.
func set_max_hearts(value):
		max_hearts = max(value, 1)		
		self.hearts = min(hearts, max_hearts)
		if emptyHeartsUI != null:
			emptyHeartsUI.size.x = max_hearts * 15
			
func set_hearts(value):
	print("Update hearts")
	hearts = clamp(value, 0, max_hearts)
	if fullHeartsUI != null:
		fullHeartsUI.size.x = hearts * 15
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.health_changed.connect(set_hearts)
	PlayerStats.max_health_changed.connect(set_max_hearts)
