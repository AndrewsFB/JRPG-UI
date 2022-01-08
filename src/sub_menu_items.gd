extends Control

onready var item_container = $Background/VScrollBar/VBoxContainer
onready var char_selection = $CharSelection

const item = preload("res://scenes/sub_menu_items_item.tscn")

var colldown = 0
var colldown_frames = 4

var character_data 

const enums = preload("res://src/enums.gd")

func _ready():
	for i in range(character_data.items.size()) :
		var new_item = item.instance()
		new_item.position = i+1
		new_item.target = character_data.items[i].target
		new_item.effect = character_data.items[i].effect
		new_item.description = character_data.items[i].description
		item_container.add_child(new_item)
		new_item.get_node("Name").text = character_data.items[i].item_name
		new_item.get_node("Quantity").text = var2str(character_data.items[i].quantity)
	self.visible = false
	move(1)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") :
		use_item()
	elif Input.is_action_just_pressed("ui_cancel") :
		get_parent().set_button_positions(0, false)

	if colldown == 0 :
		if Input.is_action_pressed("ui_down") :
			move(1)
		elif Input.is_action_pressed("ui_up") :
			move(-1)
		colldown = colldown_frames
	else :
		colldown -= 1

func use_item() :
	for item in item_container.get_children() :
		if item.get_node("Focus").visible :
			char_selection.selection = 3 if item.target == enums.ITEM_TARGET.ALL else 0
			char_selection.activate()
			self.set_process(false)
			yield(char_selection, "selected")
			self.set_process(true)
			break

func move(step):
	var last_position = item_container.get_children().size()
	var current_position = 0
	for item in item_container.get_children() :
		var focus = item.get_node("Focus")
		if focus.visible :
			current_position = item.position
			focus.visible = false
			break
	var new_position = current_position+step
	if new_position < 1 :
		new_position = last_position
	elif new_position > last_position :
		new_position = 1
	for item in item_container.get_children() :
		if item.position == new_position :
			$ItemName.text = item.get_node("Name").text
			$ItemDescription.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
			item.get_node("Focus").visible = true
			item.grab_focus()
