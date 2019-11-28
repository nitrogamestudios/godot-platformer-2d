"""Moving platform, moves to target positions given by the Waypoints node"""
extends KinematicBody2D

onready var wait_timer: Timer = $Timer
onready var waypoints: = $Waypoints

export var speed: = 400.0

var target_position: = Vector2()


func _ready() -> void:
	if not waypoints:
		print("Missing Waypoints node for %s: %s" % [name, get_path()])
		assert(waypoints)
		set_physics_process(false)
		return
	position = waypoints.get_start_position()
	target_position = waypoints.get_next_point_position()


func _physics_process(delta: float) -> void:
	var direction: = (target_position - position).normalized()
	var motion: = direction * speed * delta
	var distance_to_target: = position.distance_to(target_position)
	if motion.length() > distance_to_target:
		position = target_position
		target_position = waypoints.get_next_point_position()
		set_physics_process(false)
		wait_timer.start()
	else:
		position += motion


func _draw() -> void:
	var shape: = $CollisionShape2D
	var extents: Vector2 = shape.shape.extents * 2.0
	var rect: = Rect2(shape.position - extents / 2.0, extents)
	draw_rect(rect, Color('fff'))


func _on_Timer_timeout() -> void:
	set_physics_process(true)
