extends Area2D

var HitEffect = preload("res://Action RPG Resources/Effects/hit_effect.tscn")

signal invincibility_started
signal invincibility_ended

@onready var timer = $Timer

var invincible = false:
	set(val):
		invincible = val
		
		if invincible:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")
	get:
		return invincible

func start_invincibility(duration):
	timer.start(duration)
	self.invincible = true

func create_effect():
	var hitEffect = HitEffect.instantiate()
	
	var main = get_tree().current_scene
	main.add_child(hitEffect)
	hitEffect.global_position = global_position


func _on_timer_timeout():
	self.invincible = false


func _on_invincibility_ended():
	print("Stopped Monitoring")
	set_deferred("monitoring", true)


func _on_invincibility_started():
	print("Started Monitoring")
	set_deferred("monitoring", false)
