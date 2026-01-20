extends Label

# Drag "Gold.tres" here in the Inspector
@export var monitored_currency: CurrencyDefinition

func _ready():
	if not monitored_currency:
		printerr("CurrencyLabel Error: No CurrencyDefinition assigned!")
		return

	# Connect to the Bank
	Bank.currency_changed.connect(_on_currency_changed)
	
	# Set Initial Text
	var current_amount = Bank._wallet.get(monitored_currency.type, 0)
	_update_text(current_amount)

func _on_currency_changed(type: GameEnums.CurrencyType, new_amount: float):
	# Check if the signal matches our target Enum
	if type == monitored_currency.type:
		_update_text(new_amount)

func _update_text(amount: float):
	# Using the display name from the Resource makes it reusable!
	# "Gold: 100" or "Mana: 50"
	text = "%s: %s" % [monitored_currency.display_name, str(snapped(amount, 0.1))]
