extends CharacterBody3D

@export var Speed   = 5.0
@export var Jump_velocity = 6.0
@export var LaneChangeSpeed = 5.0

enum Lane {LEFT = -1, CENTER = 0, RIGHT = 1}
enum State {RUNNING, JUMPING, SLIDING, DEAD}

var targetLane : int = Lane.CENTER
var currentLane : int = Lane.CENTER
@export var LaneWidth = 2.0
var isSliding : bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()* delta

	if Input.is_key_pressed(KEY_SHIFT):
		if not isSliding:
			isSliding = true
			$Model/UAL1_Standard.hide()
			$Model/UAL2_Standard.show()
			$Model/UAL2_Standard/AnimationPlayer.play("Slide_Loop")
			$CollisionShape3D.scale.y = 0.5
	else:
		if isSliding:
			isSliding = false
			$Model/UAL2_Standard.hide()
			$Model/UAL1_Standard.show()
			$CollisionShape3D.scale.y = 1.0

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not isSliding:
		velocity.y = Jump_velocity
		$Model/UAL1_Standard/AnimationPlayer.play("Jump")
	elif not isSliding:
		$Model/UAL1_Standard/AnimationPlayer.play("Sprint")
		
			
	var targetX = targetLane *LaneWidth
	position.x = lerp(position.x, targetX, LaneChangeSpeed*delta)
	
	if Input.is_action_just_pressed("ui_left") and targetLane > Lane.LEFT:
		targetLane-=1
	if Input.is_action_just_pressed("ui_right") and targetLane < Lane.RIGHT:
		targetLane+=1

	move_and_slide()
