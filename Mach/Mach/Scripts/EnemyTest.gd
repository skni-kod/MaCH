extends Area2D

var speed = 10
var playerpos
var tragpos
@onready var Player = get_parent().get_node("Player")

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	playerpos = Player.position
	tragpos = (playerpos - position).normalized()

	if position.distance_to(playerpos) > 3:
		position += tragpos * speed * delta

func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage()
