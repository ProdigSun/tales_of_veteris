extends CanvasLayer

enum State {
	READY,
	READING,
	FINISHED
}

var state = State.READY

@onready var textBox = $TextBoxContainer
@onready var start_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/Start
@onready var label = $TextBoxContainer/MarginContainer/HBoxContainer/Label
@onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/End


var text_queue = []
var tween = null


# Called when the node enters the scene tree for the first time.
func _ready():
	hide_text()
	queue_text("Teste Teste Teste Teste Teste")
	queue_text("Teste Teste Teste Teste Teste 2")
	queue_text("Teste Teste Teste Teste Teste 3 Teste 3 Teste 3")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1
				end_symbol.text = "v"
				tween.kill()
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				label.visible_ratio = 0.0
				hide_text()

func queue_text(text):
	text_queue.push_back(text)

func hide_text():
	start_symbol.text = ""
	label.text = ""
	end_symbol.text = ""
	textBox.hide()

func show_text():
	tween = get_tree().create_tween()
	tween.finished.connect(on_tween_finished)
	
	start_symbol.text = "*"
	tween.tween_property(label, "visible_ratio", 1.0, 1).set_trans(Tween.TRANS_LINEAR)
	textBox.show()

func display_text():
	label.text = text_queue.pop_front()
	change_state(State.READING)
	show_text()

func on_tween_finished():
		end_symbol.text = "v"
		change_state(State.FINISHED)

func change_state(next_state):
	state = next_state
