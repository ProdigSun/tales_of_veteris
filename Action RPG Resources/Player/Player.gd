extends CharacterBody2D

const MAX_SPEED = 100
const FRICTION = 400
const ACCELERATION = 500 

enum {
	MOVE, ROLL, ATTACK
}

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
var state = MOVE
var roll_vector = Vector2.DOWN

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# AVOID ROLLING WHEN MOVIMENT IS 0, ROLLS TO LAST KNOWN LOCATION
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", roll_vector)
		
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()
		
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
		
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
		
func roll_state():
	velocity = roll_vector * MAX_SPEED * 1.5
	animationState.travel("Roll")
	move_and_slide()

func attack_state(delta):
	animationState.travel("Attack")

func roll_animation_finish():
	state = MOVE

func attack_animation_finished():
	state = MOVE
