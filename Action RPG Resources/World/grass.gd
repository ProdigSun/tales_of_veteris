extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Instanciar cena: LOAD -> INSTANTIATED -> ADICIONAR NA MAIN -> DEFINIR GLOBAL_POSITION
#
#

func _on_hurtbox_area_entered(area):
	var GrassEffect = load("res://Action RPG Resources/Effects/grass_effects.tscn")
	var grassEffect = GrassEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(grassEffect)
	grassEffect.global_position = global_position
	queue_free()
