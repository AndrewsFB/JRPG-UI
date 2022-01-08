extends Control

var enums = preload("res://src/enums.gd")

export var position : int
export var description : String
export var effect : int
export var target :int

func _ready():
	set_focus_mode(Control.FOCUS_ALL)
