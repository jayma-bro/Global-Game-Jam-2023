extends Path2D

var config: Dictionary = {}
var speed: int = 3

func _ready():
	for pos in config.path:
		print(pos.substr(1, -1))
		print(pos.get_slice(", ", 1))
		curve.add_point(Vector2(float(pos.substr(1, -1)), float(pos.get_slice(", ", 1))))

func _process(delta):
	$PathFollow3D.offset = $PathFollow3D.offset + (delta * speed)
