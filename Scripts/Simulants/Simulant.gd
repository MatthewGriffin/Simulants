extends CharacterBody3D
class_name Simulant

signal AtTarget

@onready var dummyMesh = $dummy_scene/Armature/Skeleton3D/Cube
@onready var AnimPlayer = $dummy_scene/AnimationPlayer
@onready var AnimTree = $dummy_scene/AnimationTree
@onready var StateMachine =  AnimTree["parameters/playback"]
@onready var NavAgent = $NavigationAgent3D
var CanWalk:bool
var PlayingAnimation:bool

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var _SimulantNeeds:SimulantNeeds 
var _SimulantTaskManager:SimulantTaskManager 
var Target

func Setup(gameController:GameController):
	_SimulantNeeds = SimulantNeeds.new()
	_SimulantTaskManager = SimulantTaskManager.new()
	#These have to be added to scene tree so that it can create timers 
	add_child(_SimulantNeeds)
	add_child(_SimulantTaskManager)
	_SimulantNeeds.Setup()
	_SimulantTaskManager.Setup(self, gameController)

func SetTarget(target:Target):
	NavAgent.target_position = target.InteractPoint.global_position
	Target = target.TargetObject

func ResetTarget():
	Target = null

func _process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	#Until target reached
	if CanWalk && !PlayingAnimation && !NavAgent.is_navigation_finished():
		var nextPoint = NavAgent.get_next_path_position()
		var dir = global_transform.looking_at(nextPoint).basis
		var angle = rad_to_deg(Quaternion(dir).angle_to(get_quaternion()))
		
		#if point is infront then walk 
		if angle <= 45 || angle >= 315:
			StateMachine.travel("Walk")
			SmoothLookAt(nextPoint)
			SetAnimTreeParam("parameters/Walk/blend_position", Vector2(0,1))
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
			SetAnimTreeParam("parameters/Walk/blend_position", Vector2(0,0))
	else:
		if Target && !PlayingAnimation:
			if IsLookingAt(Target.global_position, 0.01):
				AtTarget.emit()
			else:
				SmoothLookAt(Target.global_position)
		SetAnimTreeParam("parameters/Walk/blend_position", Vector2(0,0))	
	ApplyRootMotion(delta)

func ApplyRootMotion(delta:float):
	set_quaternion(get_quaternion() * AnimTree.get_root_motion_rotation())
	velocity = (AnimTree.get_root_motion_rotation_accumulator().inverse() * get_quaternion()) * AnimTree.get_root_motion_position() / delta
	set_velocity(velocity)
	move_and_slide()

func IsLookingAt(target:Vector3, threshold:float = 0)->bool:
	if to_local(target).normalized().x <= threshold:
		return true
	else: 
		return false

func SmoothLookAt(target:Vector3):
	var lookat = global_transform.looking_at(target, Vector3(0,1,0))
	lookat.basis.y = global_transform.basis.y
	lookat.basis.z = global_transform.basis.z
	global_transform = global_transform.interpolate_with(lookat, 0.1)

func SetAnimTreeParam(param:String, value):
	AnimTree.set(param,value)

func SetCanWalk(walk:bool):
	CanWalk = walk
	
func SetAnimPlaying(anim:bool):
	PlayingAnimation = anim
