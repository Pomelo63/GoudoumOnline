extends Area2D
signal hit

@export var speed = 100 ;
@export var m_sprint_gauge=100;
@export var c_sprint_gauge=0;

var idle_face = "front";
var screen_size ;
var velocity = Vector2();
var is_Atk = false
var is_Sprinting = false

func _ready():
	screen_size = get_viewport_rect().size
	c_sprint_gauge=m_sprint_gauge;
	hide();


func _process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("move_right")&& velocity.y==0:
		velocity.x += 1
		idle_face = "right"
	if Input.is_action_pressed("move_left")&& velocity.y==0:
		velocity.x -= 1
		idle_face = "left"
	if Input.is_action_pressed("move_up")&& velocity.x==0:
		velocity.y -= 1
		idle_face = "up"
	if Input.is_action_pressed("move_down") && velocity.x==0:
		velocity.y += 1
		idle_face = "front"
		
	if velocity.x != 0 :
		velocity.y=0;
	if velocity.y != 0:
		velocity.x =0;
	
		
	velocity = velocity.normalized() * speed;
	position += velocity * delta;
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.length() == 0:
		if idle_face == "front" && is_Atk==false:
			$AnimatedSprite2D.play("I_front");
		if idle_face =="up"&& is_Atk==false:
			$AnimatedSprite2D.play("I_up");
		if idle_face =="right"&& is_Atk==false:
			$AnimatedSprite2D.play("I_right");
		if idle_face =="left"&& is_Atk==false:
			$AnimatedSprite2D.play("I_left");
	else:
		if velocity.x > 0&& is_Atk==false:
			$AnimatedSprite2D.play("Right");
		if velocity.x < 0&& is_Atk==false:
			$AnimatedSprite2D.play("Left");
		if velocity.y > 0&& is_Atk==false:
			$AnimatedSprite2D.play("Down");
		if velocity.y < 0&& is_Atk==false:
			$AnimatedSprite2D.play("Up");
			
	if Input.is_action_pressed("atk"):
		is_Atk = true;
		if idle_face == "front":
			$AnimatedSprite2D.play("D_atk");
		if idle_face =="up":
			$AnimatedSprite2D.play("Up_atk");
		if idle_face =="right":
			$AnimatedSprite2D.play("R_atk");
		if idle_face =="left":
			$AnimatedSprite2D.play("L_atk");
	if Input.is_action_just_released("atk"):
		is_Atk = false;
	  
	if Input.is_action_pressed("sprint"):
		is_Sprinting = true;
		if c_sprint_gauge > 0.4:
			speed=150;
			c_sprint_gauge -= 0.4
		else:
			c_sprint_gauge = 0;
			speed=100;
			
	if Input.is_action_just_released("sprint"):
		is_Sprinting = false;
		speed=100;
			
	if is_Sprinting ==false :
		c_sprint_gauge +=0.05;


func _on_body_entered(body: Node2D):
	hide();
	hit.emit();
	$CollisionShape2D.set_deferred("disabled", true);
	
func start(pos):
	position= pos;
	show();
	$CollisionShape2D.set_deferred("disabled",false);
