extends CanvasLayer

func _ready():
	$Background/Restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	get_tree().reload_current_scene()
