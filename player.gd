extends CharacterBody3D

@export var Speed   = 5.0
@export var Jump_velocity = 4.5
@export var LaneChangeSpeed = 5.0

enum Lane {LEFT = -1, CENTER = 0, RIGHT = 1}
enum State {RUNNING, JUMPING, SLIDING, DEAD}

var targetLane : int = Lane.CENTER
var currentLane : int = Lane.CENTER
@export var LaneWidth = 2.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()* delta	
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = Jump_velocity
	var targetX = targetLane *LaneWidth
	position.x = lerp(position.x, targetX, LaneChangeSpeed*delta)
	
	if Input.is_action_just_pressed("ui_left"):
		targetLane-=1
	if Input.is_action_just_pressed("ui_right"):
		targetLane+=1

	move_and_slide()
