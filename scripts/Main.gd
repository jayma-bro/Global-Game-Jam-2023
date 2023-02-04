extends Node2D

var t0: int = 0

func _ready():
	pass


func _on_Button_pressed():
	t0 = Time.get_ticks_msec()
	print(t0)
	
