extends Control

# Avoiding key smash
var colldown_frames = 7
var colldown = 0

# Menu parameters
var menu_buttons_position = []
var options_position = Vector2(0, 0)
var menu_position = Vector2(-50, -50)
var menu_spacing = 220
var first_position = Vector2(menu_position.x,menu_position.y-menu_spacing)
var second_position = Vector2(menu_position.x+(menu_spacing*0.65),menu_position.y-(menu_spacing*0.65))
var third_position = Vector2(menu_position.x+menu_spacing,menu_position.y)
var fourth_position = Vector2(menu_position.x+(menu_spacing*0.65),menu_position.y+(menu_spacing*0.65))
var fifth_position = Vector2(menu_position.x,menu_position.y+menu_spacing)
var sixth_position = Vector2(menu_position.x-(menu_spacing*0.65),menu_position.y+(menu_spacing*0.65))
var seventh_position = Vector2(menu_position.x-menu_spacing,menu_position.y)
var eighth_position = Vector2(menu_position.x-(menu_spacing*0.65),menu_position.y-(menu_spacing*0.65))
var menu_recoil = 670
var menu_pushed = false
var menu_rotation = 0

# Nodes
onready var options = $Options
onready var option_name = $Options/OptionName
onready var current_option = $Options/Option1
onready var option1 = $Options/Option1
onready var option2 = $Options/Option2
onready var option3 = $Options/Option3
onready var option4 = $Options/Option4
onready var option5 = $Options/Option5
onready var option6 = $Options/Option6
onready var option7 = $Options/Option7
onready var option8 = $Options/Option8

# Sub menus
const sub_menu_items = preload("res://scenes/sub_menu_items.tscn")

# Data
const character_data = preload("res://src/character_data.gd")

# Enums
const enums = preload("res://src/enums.gd")
const ITEM_TARGET = enums.ITEM_TARGET
const ITEM_EFFECT = enums.ITEM_EFFECT

func _ready() :
	options_position = options.position
	option_name.set_text(current_option.editor_description)
	set_button_positions(0, false)
	show_submenu(false)

func _process(delta) :
	var sub_menu = null
	if self.has_node("SubMenu"):
		sub_menu = self.get_node("SubMenu")

	animate_options(delta, sub_menu)
	
	if sub_menu == null :
		get_controls()

func get_controls() :
	if colldown == 0 :
		if !menu_pushed :
			if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_down"):
				set_button_positions(-1, menu_pushed)
				colldown = colldown_frames
				menu_rotation -= 50
			elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up"):
				set_button_positions(1, menu_pushed)
				colldown = colldown_frames
				menu_rotation += 50
		if Input.is_action_just_pressed("ui_accept") :
			set_button_positions(0, true)
			colldown = colldown_frames
		elif Input.is_action_just_pressed("ui_cancel"):
			set_button_positions(0, false)
			colldown = colldown_frames
		
	if colldown > 0 :
		colldown -= 1

func animate_options(delta, sub_menu):

	option1.rect_position = option1.rect_position.linear_interpolate(menu_buttons_position[0], delta + 0.2)
	option2.rect_position = option2.rect_position.linear_interpolate(menu_buttons_position[1], delta + 0.2)
	option3.rect_position = option3.rect_position.linear_interpolate(menu_buttons_position[2], delta + 0.2)
	option4.rect_position = option4.rect_position.linear_interpolate(menu_buttons_position[3], delta + 0.2)
	option5.rect_position = option5.rect_position.linear_interpolate(menu_buttons_position[4], delta + 0.2)
	option6.rect_position = option6.rect_position.linear_interpolate(menu_buttons_position[5], delta + 0.2)
	option7.rect_position = option7.rect_position.linear_interpolate(menu_buttons_position[6], delta + 0.2)
	option8.rect_position = option8.rect_position.linear_interpolate(menu_buttons_position[7], delta + 0.2)
	
	options.position.x = lerp(options.position.x, options_position.x, delta + 0.2)
	
	for opt in options.get_children() :
		var groups = opt.get_groups()
		if groups.size() > 0 :
			if groups[0] == "option" and opt.rect_position.y < current_option.rect_position.y:
				opt.material = current_option.material
				current_option.material = null
				current_option = opt
				option_name.set_text(opt.editor_description)
	
	if sub_menu != null :
		if sub_menu.modulate.a > 0 and menu_pushed:
			sub_menu.modulate.a = lerp(sub_menu.modulate.a, 1, 0.05)
		
		if sub_menu.modulate.a < 1 and !menu_pushed :
			sub_menu.modulate.a = lerp(sub_menu.modulate.a, 0, 0.16)
		
		if round(sub_menu.modulate.a) == 0 and !menu_pushed:
			sub_menu.visible = false
			sub_menu.queue_free()

func set_button_positions(step, pushed) :
	if step > 1 or step < -1:
		push_error("Invalid step on set_button_position.")
	
	if menu_buttons_position.size() == 0 :
		menu_buttons_position = [first_position, second_position, third_position, fourth_position, fifth_position, sixth_position, seventh_position, eighth_position]
	
	var menu_previous = menu_buttons_position.duplicate()
	
	if step == -1:
		menu_buttons_position[0] = menu_previous[7]
	else:
		menu_buttons_position[0] = menu_previous[step]
		
	menu_buttons_position[1] = menu_previous[1+step]
	menu_buttons_position[2] = menu_previous[2+step]
	menu_buttons_position[3] = menu_previous[3+step]
	menu_buttons_position[4] = menu_previous[4+step]
	menu_buttons_position[5] = menu_previous[5+step]
	menu_buttons_position[6] = menu_previous[6+step]

	if step == 1:
		menu_buttons_position[7] = menu_previous[0]
	else:
		menu_buttons_position[7] = menu_previous[7+step]
	
	if pushed and !menu_pushed: 
		menu_pushed = true
		options_position.x -= menu_recoil
		show_submenu(true)
	elif !pushed and menu_pushed:
		menu_pushed = false
		options_position.x += menu_recoil
		show_submenu(false)

func show_submenu(opened):
	options.modulate.a = 0.2 if (opened) else 1.0
	if opened :
		if !self.has_node("SubMenu") :
			var sub_menu = sub_menu_items.instance()
			sub_menu.character_data = mock_character_data()
			sub_menu.rect_position.x = 550
			sub_menu.rect_position.y = 145
			self.add_child(sub_menu)
			sub_menu.visible = opened
			sub_menu.modulate.a = 0.1

func mock_character_data():
	var data = character_data.new()
	data.add_item(1, "Item de teste nº 1", 4, "Uma descriçao a ser usada como teste", ITEM_TARGET.ONE, ITEM_EFFECT.HEAL)
	data.add_item(2, "Item de teste nº 2", 9, "Uma descriçao a ser usada como teste", ITEM_TARGET.ALL, ITEM_EFFECT.BUFF)
	data.add_item(3, "Item de teste nº 3", 2, "Uma descriçao a ser usada como teste", ITEM_TARGET.ONE, ITEM_EFFECT.STATUS)
	data.add_item(4, "Item de teste nº 4", 3, "Uma descriçao a ser usada como teste", ITEM_TARGET.ALL, ITEM_EFFECT.HEAL)
	data.add_item(5, "Item de teste nº 5", 4, "Uma descriçao a ser usada como teste", ITEM_TARGET.ONE, ITEM_EFFECT.BUFF)
	data.add_item(6, "Item de teste nº 6", 5, "Uma descriçao a ser usada como teste", ITEM_TARGET.ALL, ITEM_EFFECT.STATUS)
	data.add_item(7, "Item de teste nº 7", 8, "Uma descriçao a ser usada como teste", ITEM_TARGET.ONE, ITEM_EFFECT.HEAL)
	data.add_item(8, "Item de teste nº 8", 7, "Uma descriçao a ser usada como teste", ITEM_TARGET.ALL, ITEM_EFFECT.BUFF)
	data.add_item(9, "Item de teste nº 9", 14, "Uma descriçao a ser usada como teste", ITEM_TARGET.ONE, ITEM_EFFECT.STATUS)
	data.add_item(10, "Item de teste nº 10", 15, "Uma descriçao a ser usada como teste", ITEM_TARGET.ALL, ITEM_EFFECT.HEAL)
	data.add_item(11, "Item de teste nº 11", 48, "Uma descriçao a ser usada como teste", ITEM_TARGET.ONE, ITEM_EFFECT.BUFF)
	return data
