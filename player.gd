extends CharacterBody3D

@export var Speed   = 5.0
@export var Jump_velocity = 6.0
@export var LaneChangeSpeed = 5.0
@export var TireSpinSpeed = 15.0

enum Lane {LEFT = -1, CENTER = 0, RIGHT = 1}
enum State {RUNNING, JUMPING, SLIDING, DEAD}

var targetLane : int = Lane.CENTER
var currentLane : int = Lane.CENTER
@export var LaneWidth = 3.0
var isSliding : bool = false
var slideTween : Tween

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()* delta

	# Jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not isSliding:
		velocity.y = Jump_velocity

	# Sliding
	if Input.is_key_pressed(KEY_SHIFT) and is_on_floor() and not isSliding:
		isSliding = true
		$CollisionShape3D.scale.y = 0.5

		if slideTween:
			slideTween.kill()

		slideTween = create_tween()
		slideTween.set_trans(Tween.TRANS_QUAD)
		slideTween.set_ease(Tween.EASE_OUT)
		slideTween.tween_property($Model, "scale:y", 0.2, 0.2)
		slideTween.parallel().tween_property($CollisionShape3D, "scale:y", 0.2, 0.4)
		slideTween.tween_interval(0.5)
		slideTween.tween_property($Model, "scale:y", 1.0, 0.2)
		slideTween.parallel().tween_property($CollisionShape3D, "scale:y", 1.0, 0.4)
		slideTween.tween_callback(func():
			isSliding = false
		)
	
	var targetX = targetLane * LaneWidth
	position.x = lerp(position.x, targetX, LaneChangeSpeed * delta)

	if Input.is_action_just_pressed("ui_left") and targetLane > Lane.LEFT:
		targetLane -= 1
	if Input.is_action_just_pressed("ui_right") and targetLane < Lane.RIGHT:
		targetLane += 1

	move_and_slide()

	# Check collision with obstacles
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("obstacle"):
			die()

func die():
	get_parent().get_node("DeathScreen").show()
	set_physics_process(false)
