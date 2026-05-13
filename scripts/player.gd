extends CharacterBody2D

@export var speed = 100
var current_dir = "none"

var enemy_in_range = false
var enemy_atk_cd = true
var health = 100
var player_alive = true
var attack_in_progress = false

var slime_damage = 10

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	if player_alive:
		player_movement(delta)
		if enemy_in_range:
			gets_attacked()
		attack()
		if health < 1:
			player_alive = false
			print("Player killed.")
			$AnimatedSprite2D.play("death")
	
func gets_attacked():
	if enemy_atk_cd:
		health -= slime_damage
		enemy_atk_cd = false
		$AttackTimer.start()
		print("player - ", str(slime_damage), " hp. " + "HP : " + str(health))
	
func player_movement(delta):
	if Input.is_action_pressed("move_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("move_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("move_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("move_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity = Vector2.ZERO
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	if dir == "left":
		anim.flip_h = true
	else:
		anim.flip_h = false
	if dir == "right":
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if !attack_in_progress:
				anim.play("side_idle")
	elif dir == "left":
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if !attack_in_progress:
				anim.play("side_idle")
	elif dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if !attack_in_progress:
				anim.play("front_idle")
	elif dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if !attack_in_progress:
				anim.play("back_idle")

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = false
		
func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		Global.player_currently_atttacking = true
		attack_in_progress = true
		if dir == "right" or dir == "left":
			if dir == "left":
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$DealAttackTimer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$DealAttackTimer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$DealAttackTimer.start()
	
func player():
	pass

func _on_attack_timer_timeout() -> void:
	enemy_atk_cd = true

func _on_deal_attack_timer_timeout() -> void:
	# $DealAttackTimer.stop()
	Global.player_currently_atttacking = false
	attack_in_progress = false
