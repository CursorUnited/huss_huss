extends Node3D

var score : int = 0

@export var ObstacleScene: Array[PackedScene]= []
@export var MinSpawnTime : float = 2.0
@export var MaxSpawnTime : float = 2.0
@export var SpawnDistance : float = -20.0

var lanePositions = [-2.0, 0.0, 2.0]


func _on_score_timer_timeout() -> void:
	
	pass # Replace with function body.


func _on_spawn_timer_timeout() -> void:
	if ObstacleScene.is_empty():
		return

	var obstacleScene = ObstacleScene[randi() % len(ObstacleScene)]

	var openLane = randi() % 3
	for i in range(3):
		if i != openLane:
			var obstacle = obstacleScene.instantiate()
			obstacle.position = Vector3(lanePositions[i], 0, SpawnDistance)
			$ObstacleContainer.add_child(obstacle)

	$SpawnTimer.wait_time = randf_range(MinSpawnTime, MaxSpawnTime)
