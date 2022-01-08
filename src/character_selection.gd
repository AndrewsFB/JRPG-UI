extends Popup

onready var char1 = $HBoxContainer/Char1
onready var char2 = $HBoxContainer/Char2
onready var char3 = $HBoxContainer/Char3
onready var flash1 = $HBoxContainer/Char1/AnimationPlayer
onready var flash2 = $HBoxContainer/Char2/AnimationPlayer
onready var flash3 = $HBoxContainer/Char3/AnimationPlayer
onready var default_modulate = $HBoxContainer/Char1.modulate

enum SELECTION {ONE, TWO, TREE, ALL}

export var selection = SELECTION.ONE

signal selected

func _ready():
	self.set_process(false)

func _process(_delta):

	if selection != SELECTION.ALL:
		if Input.is_action_just_pressed("ui_right") :
			selection += 1 if selection != SELECTION.TREE else -2
		elif Input.is_action_just_pressed("ui_left") :
			selection += -1 if selection != SELECTION.ONE else +2

	if Input.is_action_just_pressed("ui_accept") :
		self.emit_signal("selected")
	elif Input.is_action_just_pressed("ui_cancel") :
		self.emit_signal("selected")

	match selection:
		SELECTION.ONE:
			flash1.play("flash")
			flash2.stop()
			char2.modulate = default_modulate
			flash3.stop()
			char3.modulate = default_modulate
		SELECTION.TWO:
			flash2.play("flash")
			flash1.stop()
			char1.modulate = default_modulate
			flash3.stop()			
			char3.modulate = default_modulate
		SELECTION.TREE:
			flash3.play("flash")
			flash1.stop()
			char1.modulate = default_modulate
			flash2.stop()			
			char2.modulate = default_modulate
		SELECTION.ALL:
			flash1.play("flash")
			flash2.play("flash")
			flash3.play("flash")

func activate():
	self.set_process(true)
	self.popup()

func _on_CharSelection_selected():
	self.set_process(false)
	self.hide()