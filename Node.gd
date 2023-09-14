extends Node

@export var max_health = 1.0

@onready var health = max_health:
	set(val):
		health = val
		if health <= 0:
			emit_signal("death")
	get:	
		return health
		
signal death
