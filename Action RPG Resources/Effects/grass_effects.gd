extends Node2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.frame = 0
	sprite.play("Animation")



func _on_animated_sprite_2d_animation_finished():
	queue_free()
