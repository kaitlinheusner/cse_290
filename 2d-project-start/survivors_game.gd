extends Node2D

var wave = 1 
const total_waves = 3
var mobs_to_spawn = 0
var active_mobs = 0
@onready var wave_label = %wave_label
@onready var wave_node = %Wave	

func _ready():
	start_wave()
	
func start_wave (): 
	if wave > total_waves: 
		end_game()
		return
		
	wave_label.text = "Wave " + str(wave)
	wave_label.show()
	wave_node.show()
	
	await get_tree().create_timer(1.5).timeout
	
	wave_label.hide()
	wave_node.hide()
	
	mobs_to_spawn = wave * 5
	active_mobs = mobs_to_spawn
	spawn_mobs()
	
func spawn_mobs():
	for i in range(mobs_to_spawn):
		spawn_mob()
		await get_tree().process_frame

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	new_mob.tree_exited.connect(_on_mob_destroyed)
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	
func _on_mob_destroyed(): 
	active_mobs -= 1
	if active_mobs <=0: 
		if wave <= total_waves: 
			wave += 1
			start_wave()
		else: 
			end_game()

func _on_player_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true
#
func end_game(): 
	wave_label.text = "You Win!"
	wave_label.show()
	wave_node.show()
	get_tree().paused = true 
	
