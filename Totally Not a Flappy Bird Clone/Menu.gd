extends Control

var highscore = 0
var save_path = "user://save.dat"

func load_Time():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			highscore = file.get_var()
			file.close()

func _ready():
	load_Time()
	get_node("Label").text = "Highscore: " + str(highscore)

func _input(event):
	if event.is_action_pressed("Flap"):
		visible = false
		get_tree().paused = false
