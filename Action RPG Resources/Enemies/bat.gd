extends CharacterBody2D

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200

@onready var sprite = $AnimatedSprite2D
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softCollisionArea = $SoftCollisionArea
@onready var wanderController = $WanderController
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

enum {
	IDLE, WANDER, CHASE
}

var state = IDLE

func _ready():
	velocity = Vector2.ZERO
	state = pick_random_state([IDLE, WANDER])
	
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

			
			seek_player()
			print(wanderController.get_time_left())
			if wanderController.get_time_left() == 0:
				print("Here")
				state = pick_random_state([IDLE, WANDER])
				print(str(state) + "********")				
				wanderController.start_wander_timer(randi_range(1, 3))
				
		WANDER:
			print("wander" + str(global_position.distance_to(wanderController.target_position)) + str(global_position) + str(wanderController.target_position))
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randi_range(1, 3))
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
			if global_position.distance_to(wanderController.target_position) <= 1:
				print("broke wander" + str(global_position.distance_to(wanderController.target_position)))
				state = pick_random_state([IDLE, WANDER])
			sprite.flip_h = velocity.x < 0
			
		CHASE:
			print(" CHASING *******")				
			var player = playerDetectionZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
	if softCollisionArea.is_colliding():
		var push_vector = softCollisionArea.generate_push_vector()
		velocity += push_vector * delta * 400
	move_and_slide()
	
func seek_player():
	if playerDetectionZone.can_see_player():
		print("Player found")
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
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



func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("End")


func _on_hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")
