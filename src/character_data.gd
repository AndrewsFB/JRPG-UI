extends Object

const item = preload("res://src/item.gd")

var items = []

func add_item(id, name, quantity, description, target, effect):
    var new_item = item.new()
    new_item.id = id
    new_item.item_name = name
    new_item.quantity = quantity
    new_item.description = description
    new_item.target = target
    new_item.effect = effect
    items.append(new_item)
    