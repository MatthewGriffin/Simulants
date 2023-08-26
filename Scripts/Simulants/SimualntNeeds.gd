extends Node
class_name SimulantNeeds

signal NeedUpdated
signal NeedFulfilled

var Energy:float = SimulantSettings.DEFAULT_ENERGY
var Hunger:float = SimulantSettings.DEFAULT_HUNGER
var Social:float = SimulantSettings.DEFAULT_SOCIAL
var Fun:float = SimulantSettings.DEFAULT_FUN
var TargetEnergy:float = SimulantSettings.DEFAULT_ENERGY
var TargetHunger:float = SimulantSettings.DEFAULT_HUNGER
var TargetSocial:float = SimulantSettings.DEFAULT_SOCIAL
var TargetFun:float = SimulantSettings.DEFAULT_FUN
var Timers:Dictionary
# Called when the node enters the scene tree for the first time.
func Setup():
	CreateNeedTimer(SimulantSettings.TYPE_ENERGY, SimulantSettings.BASE_DECAY_RATE)
	CreateNeedTimer(SimulantSettings.TYPE_HUNGER, SimulantSettings.BASE_DECAY_RATE * 3)
	CreateNeedTimer(SimulantSettings.TYPE_SOCIAL, SimulantSettings.BASE_DECAY_RATE / 2)
	CreateNeedTimer(SimulantSettings.TYPE_FUN, SimulantSettings.BASE_DECAY_RATE / 3)

func CreateNeedTimer(NeedToUpdate:String, amountToChangePerSecond:float):
	var timer = Timer.new()
	timer.timeout.connect(SetNeedTarget.bind(NeedToUpdate, amountToChangePerSecond * SimulantSettings.NEED_UPDATE_RATE))
	add_child(timer)
	timer.start(SimulantSettings.NEED_UPDATE_RATE)
	Timers.merge({NeedToUpdate: timer})

func PauseNeedTimer(TimerToPause:String, pause:bool = true):
	Timers[TimerToPause].paused = pause

func SetNeedTarget(NeedToUpdate:String, amountToChangeBy:float):
	var need = clampf(get("Target" + NeedToUpdate) + amountToChangeBy, SimulantSettings.MIN_NEED, SimulantSettings.MAX_NEED)
	set("Target" + NeedToUpdate, need)

func _process(delta):
	UpdateNeeds(delta)

func UpdateNeeds(delta:float):
	UpdateNeed("Hunger", delta)
	UpdateNeed("Energy", delta)
	UpdateNeed("Social", delta)
	UpdateNeed("Fun", delta)

func UpdateNeed(NeedToUpdate:String, delta:float):
	var target = get("Target" + NeedToUpdate)
	var current = get(NeedToUpdate)
	
	#if need is being filled
	if current <= target:
		var newNeed = clampf(current + (2 * delta), SimulantSettings.MIN_NEED, SimulantSettings.MAX_NEED)
		set(NeedToUpdate, newNeed)
		NeedUpdated.emit(NeedToUpdate, newNeed)
		#if need is fulfilled next frame
		if current < target && newNeed == 100:
			NeedFulfilled.emit()	
	#if need is being drained
	else:
		var newNeed = clampf(current - (2 * delta), SimulantSettings.MIN_NEED, SimulantSettings.MAX_NEED)
		set(NeedToUpdate, newNeed)
		NeedUpdated.emit(NeedToUpdate, newNeed)
