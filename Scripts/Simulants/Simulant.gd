extends CharacterBody3D

class_name Simulant

signal AtTarget

@onready var dummyMesh = $dummy_scene/Armature/Skeleton3D/Cube
@onready var AnimTree = $dummy_scene/AnimationTree
@onready var StateMachine =  AnimTree["parameters/playback"]
@onready var NavAgent = $NavigationAgent3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var _SimulantNeeds:SimulantNeeds 
var Target

func Setup():
	_SimulantNeeds = SimulantNeeds.new()
	#SimulantNeeds has to be added to scene tree so that it can create timers 
	add_child(_SimulantNeeds)
	_SimulantNeeds.Setup()

func SetTarget(target):
	NavAgent.target_position = target.global_position
	Target = target

func _process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	#Until target reached
	if !NavAgent.is_navigation_finished():
		var nextPoint = NavAgent.get_next_path_position()
		var dir = global_transform.looking_at(nextPoint).basis
		var angle = rad_to_deg(Quaternion(dir).angle_to(get_quaternion()))
		var currentAnim = StateMachine.get_current_node()
		
		#if point is infront then walk 
		if angle <= 45 || angle >= 315:
			StateMachine.travel("Walk")
			SmoothLookAt(nextPoint)
			SetAnimTreeParam("parameters/Walk/blend_position", Vector2(0,1))
			ApplyRootMotion(delta)
		#if point is to our side or behind
		else:
			#convert nextpoint to be direction from simulant
			var loc = to_local(nextPoint).normalized()
			if loc.x > 0 && angle > 270: 
				StateMachine.travel("Turn_Right_45")
			elif loc.x > 0:
				StateMachine.travel("Turn_Right")
			elif loc.x < 0 && angle > 45: 
				StateMachine.travel("Turn_Left_45")
			elif loc.x < 0:
				StateMachine.travel("Turn_Left")
			
			ApplyRootMotion(delta)
			SetAnimTreeParam("parameters/Walk/blend_position", Vector2(0,0))
	else:
		AtTarget.emit()
		SetAnimTreeParam("parameters/Walk/blend_position", Vector2(0,0))	

func ApplyRootMotion(delta:float):
	set_quaternion(get_quaternion() * AnimTree.get_root_motion_rotation())
	velocity = (AnimTree.get_root_motion_rotation_accumulator().inverse() * get_quaternion()) * AnimTree.get_root_motion_position() / delta
	set_velocity(velocity)
	move_and_slide()

func SmoothLookAt(target:Vector3):
	var lookat = global_transform.looking_at(target)
	lookat.basis.z = global_transform.basis.z
	lookat.basis.y = global_transform.basis.y
	global_transform = global_transform.interpolate_with(lookat, 0.1)

func SetAnimTreeParam(param:String, value):
	AnimTree.set(param,value)
