extends CharacterBody2D

var move_speed : float = 100.0
var heart = 3
var is_invincible = false
var invincibility_time = 1.0
var heart_list : Array[AnimatedSprite2D] = []

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	var hearts_parent = $Healthbar/HBoxContainer
	heart_list = []
	for child in hearts_parent.get_children():
		if child is AnimatedSprite2D:
			heart_list.append(child)
	update_heart_display()

func _physics_process(_delta: float) -> void:
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = direction * move_speed

	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false

	if velocity.length() > 0:
		animated_sprite.play("Move")
	else:
		animated_sprite.play("Stand")

	move_and_slide()

func update_heart_display():
	for i in range(heart_list.size()):
		if i < heart:
			heart_list[i].play("Full")
		else:
			heart_list[i].play("Empty")

func take_damage():
	if heart > 0 and not is_invincible:
		heart -= 1
		update_heart_display()
		print("Gracz otrzymał obrażenia! Pozostało serc:", heart)
		is_invincible = true
		$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)  
		await get_tree().create_timer(invincibility_time).timeout
		$AnimatedSprite2D.modulate = Color(1, 1, 1)  
		is_invincible = false
	if heart <= 0:
		die()

func die():
	print("Gracz zginął!")
	get_tree().reload_current_scene()
