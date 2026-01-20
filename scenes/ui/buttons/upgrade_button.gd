extends Button

@export var upgrade_resource: LevelableUpgrade

func _ready():
	pressed.connect(_on_pressed)
	
	# NEW: Listen for changes from the Manager (e.g., when Loading)
	UpgradeManager.upgrade_leveled_up.connect(_on_level_changed)
	
	# Initial update
	_update_label()

func _on_pressed():
	# We don't need to update label here anymore, 
	# because the signal below will trigger it automatically!
	UpgradeManager.try_purchase_level(upgrade_resource)

func _on_level_changed(changed_id: String, new_lvl: int):
	# Check matching ID
	if upgrade_resource and upgrade_resource.id == changed_id:
		_update_label()

func _update_label():
	if upgrade_resource == null: return
	
	var cost = UpgradeManager.get_current_cost(upgrade_resource)
	
	# FIX: Use .id (String) instead of .target_stat (Enum)
	var current_lvl = UpgradeManager.get_upgrade_level(upgrade_resource.id)
	
	text = "%s (Lvl %d)\nCost: %s Gold" % [
		upgrade_resource.display_name, 
		current_lvl, 
		str(snapped(cost, 0.1))
	]
