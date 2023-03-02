extends KinematicBody2D

const up = Vector2(0, -1)
const flap = 200
const max_fall_speed = 200
const gravity = 10

var motion = Vector2()
var Wall = preload("res://WallNode.tscn")
var highscore = 0
var score = 0

var save_path = "user://save.dat"

func save_Time():
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	
	if error == OK:
		file.store_var(score)
		file.close()

func load_Time():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			highscore = file.get_var()
			file.close()

func _ready(): #function that occurs just as the game will "start"_ready():
	load_Time()
	motion.y = -flap
	pass

func _physics_process(delta): #function that occurs every physics process (I believe it's based on time delta? not entirely sure)
	motion.y += gravity
	if motion.y > max_fall_speed:
		motion.y = max_fall_speed
	
	if Input.is_action_just_pressed("Flap"):
		motion.y = -flap
	motion = move_and_slide(motion, up) 

	get_parent().get_parent().get_node("CanvasLayer/RichTextLabel").text = str(score)

func Wall_reset(): #Wall node spawner, I think HAHHAAHAHAHHA
	var Wall_instance = Wall.instance()
	Wall_instance.position = Vector2(275, rand_range(-50,50))
	get_parent().call_deferred("add_child", Wall_instance)
	
func _on_Resetter_body_entered(body): #when wall enters outside of the player screen, reset the wall
	if body.name == "Walls":
		body.queue_free()
		Wall_reset()
	
func _on_Detect_area_entered(area): #for getting points
	if area.name == "PointArea":
		get_parent().get_node("ScoreFX").play()
		score += 1

func _on_Detect_body_entered(body): #when the player block hits a wall, then bye-bye, but also you have to save the score
	if body.name == "Walls" or body.name == "LavaFloor":
		if highscore < score:
			save_Time()
		get_tree().reload_current_scene() #find a way to replace this because there should be a way to reset the scene without having to reset the score thingy
