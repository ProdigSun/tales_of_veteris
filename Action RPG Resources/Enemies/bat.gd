extends CharacterBody2D

@onready var stats = $Stats

func _ready():
	velocity = Vector2.ZERO
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	stats.health -= 1
	
	if stats.health <= 0:
		queue_free()
	
	velocity = area.knockback_vector * 100

