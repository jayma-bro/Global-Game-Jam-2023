extends Node

func LoadGame() -> Dictionary:
	var save: Dictionary = {}
	var save_file = null
	if not FileAccess.file_exists("user://savegame.save"):
		save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		save_file.store_string(JSON.stringify(Settings.StartSave))
		save = Settings.StartSave.duplicate(true)
	else:
		save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(save_file.get_as_text())
		save = test_json_conv.get_data()
	save_file.close()
	return save

func SaveGame() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_string(JSON.stringify(Settings.GameSave))
	save_file.close()
