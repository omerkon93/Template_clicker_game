class_name ClickProducer extends Node

@export var currency_type: GameEnums.CurrencyType = GameEnums.CurrencyType.GOLD
@export var stat_def: StatDefinition
# Using the Array allows multiple upgrades to boost this click
@export var contributing_upgrades: Array[LevelableUpgrade] = []

# These variables to tweak the visuals
@export_group("Visuals")
@export var bounce_scale: Vector2 = Vector2(0.9, 0.9) # Shrink to 90%
@export var bounce_duration: float = 0.05

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
	var text_str = "+" + NumberFormatter.format_value(amount)
	
	SignalBus.request_floating_text.emit(mouse_pos, text_str, Color.GOLD)
	
	_play_bounce_animation()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_clicked()

func _play_bounce_animation():
	var parent = get_parent()
	# Tweens work best on Control nodes (Buttons) or Node2Ds (Sprites)
	if not (parent is Control or parent is Node2D): return
	
	# CRITICAL: We must set the pivot to the center, otherwise it shrinks to the top-left corner!
	# We try to calculate center based on the node type
	if parent is Control:
		parent.pivot_offset = parent.size / 2
	
	# Create the Tween
	var tween = create_tween()
	
	# 1. Squash (Shrink fast)
	tween.tween_property(parent, "scale", bounce_scale, bounce_duration)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
	# 2. Stretch (Return to normal)
	tween.tween_property(parent, "scale", Vector2.ONE, bounce_duration)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
