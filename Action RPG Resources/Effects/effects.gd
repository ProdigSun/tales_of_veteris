extends AnimatedSprite2D


func _ready():
	self.animation_finished.connect(_on_animation_finished)
	frame = 0
	play("Animation")
 


func _on_animation_finished():
	queue_free()
