extends Node

# Global signal to request a popup
# position: Screen coordinates (Vector2)
# text: The string to display (e.g., "+10")
# color: The text color
signal request_floating_text(position: Vector2, text: String, color: Color)
