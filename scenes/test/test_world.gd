extends Control

var gold : GameEnums.CurrencyType = GameEnums.CurrencyType.GOLD
func _ready() -> void:
	Bank.add_currency(gold, 10000)

func _on_save_pressed() -> void:
	SaveSystem.save_game()

func _on_load_pressed() -> void:
	SaveSystem.load_game()
