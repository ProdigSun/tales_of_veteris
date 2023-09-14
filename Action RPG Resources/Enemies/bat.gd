extends CharacterBody2D

@onready var stats = $Stats

func _ready():
	velocity = Vector2.ZERO
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * 100


func _on_stats_death():
	queue_free()
