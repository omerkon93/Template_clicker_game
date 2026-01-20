class_name ClickProducer extends Node

@export var currency_type: GameEnums.CurrencyType = GameEnums.CurrencyType.GOLD
@export var stat_def: StatDefinition
# Using the Array allows multiple upgrades to boost this click
@export var contributing_upgrades: Array[LevelableUpgrade] = []

func _ready():
	var parent = get_parent()
	if parent is BaseButton:
		parent.pressed.connect(_on_clicked)
	elif parent is Control:
		parent.gui_input.connect(_on_gui_input)

func _on_clicked():
	if not stat_def: return

	# FIX: Trust GameStats to do the math. 
	# We removed the manual 'for' loop because get_stat_value now does that internally!
	var amount = GameStats.get_stat_value(stat_def, contributing_upgrades)
	
	Bank.add_currency(currency_type, amount)
	
	# Visuals
	var mouse_pos = get_viewport().get_mouse_position()
	var text_str = "+" + str(snapped(amount, 0.1))
	SignalBus.request_floating_text.emit(mouse_pos, text_str, Color.GOLD)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_clicked()
