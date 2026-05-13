extends CharacterBody2D

@export var speed = 60
var player_chase = false
var player = null
var is_alive = true
@export var health = 100
var player_can_atk = false
var can_take_damage = true

func _physics_process(delta: float) -> void:
	if is_alive:
		deal_with_damage()
		movement_manager()
	else:
		await ($AnimatedSprite2D.animation_finished)
		self.queue_free()
	anim_manager()
	
func movement_manager():
	if player_chase:
		position += (player.position - position)/speed

func anim_manager():
	if is_alive:
		if player_chase:
			if (player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("death")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player_chase = false
	player = null
	
func enemy():
	pass

func _on_enemy_hitbow_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_can_atk = true

func _on_enemy_hitbow_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_can_atk = false
		
func deal_with_damage():
	if player_can_atk and Global.player_currently_atttacking and can_take_damage:
		health -= 20
		can_take_damage = false
		$TakeDamageCooldown.start()
		print("Slime takes 20 damage. HP: " + str(health))
		if health < 1:
			is_alive = false
			print("Slime died.")

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
