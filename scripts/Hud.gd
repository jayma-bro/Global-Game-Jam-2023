extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	$RunTree.visible = false
	$VBoxButton.visible = false
	$Stop.visible = true


func _on_stop_pressed():
	$RunTree.visible = true
	$VBoxButton.visible = true
	$Stop.visible = false
