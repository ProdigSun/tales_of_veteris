extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func is_colliding():
		var overlapping_areas = get_overlapping_areas()
		return overlapping_areas.size() > 0

func generate_push_vector():
	var push_vector = Vector2.ZERO
	var overlapping_areas = get_overlapping_areas()
	
	if overlapping_areas.size() > 0:
		var area = overlapping_areas[0]
		
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	return push_vector
