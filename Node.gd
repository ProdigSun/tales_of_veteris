extends Node

@export var max_health = 1.0:
	set(val):
		max_health = val
		self.health = min(health, max_health)
		emit_signal("max_health_changed", val)

var health = max_health:
	set(val):
		health = val
		emit_signal("health_changed", health)
		if health <= 0:
			emit_signal("death")
	get:	
		return health
		
signal death
signal health_changed(value)
signal max_health_changed(value)

func _ready():
	self.health = max_health
