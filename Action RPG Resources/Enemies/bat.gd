extends CharacterBody2D

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200

@onready var sprite = $AnimatedSprite2D
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox

enum {
	IDLE, WANDER, CHASE
}

var state = IDLE

func _ready():
	velocity = Vector2.ZERO
	
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
func seek_player():
	if playerDetectionZone.can_see_player():
		print("Player found")
		state = CHASE

func _on_hurtbox_area_entered(area):
	hurtbox.start_invincibility(0.5)
	hurtbox.create_effect()
	stats.health -= area.damage
	velocity = area.knockback_vector * 100


func _on_stats_death():
	var DeathEffect = load("res://Action RPG Resources/Enemies/enemy_death_effect.tscn")
	var deathEffect = DeathEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()

