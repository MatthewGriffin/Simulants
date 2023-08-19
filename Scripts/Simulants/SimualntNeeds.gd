extends Node

class_name SimulantNeeds

signal NeedUpdated

var Energy:float = SimulantSettings.DEFAULT_ENERGY
var Hunger:float = SimulantSettings.DEFAULT_HUNGER
var Social:float = SimulantSettings.DEFAULT_SOCIAL
var Fun:float = SimulantSettings.DEFAULT_FUN

# Called when the node enters the scene tree for the first time.
func Setup():
	CreateNeedTimer(SimulantSettings.TYPE_ENERGY, SimulantSettings.BASE_DECAY_RATE)
	CreateNeedTimer(SimulantSettings.TYPE_HUNGER, SimulantSettings.BASE_DECAY_RATE * 3)
	CreateNeedTimer(SimulantSettings.TYPE_SOCIAL, SimulantSettings.BASE_DECAY_RATE / 2)
	CreateNeedTimer(SimulantSettings.TYPE_FUN, SimulantSettings.BASE_DECAY_RATE)

func CreateNeedTimer(NeedToUpdate:String, amountToChangePerSecond:float):
	var timer = Timer.new()
	timer.timeout.connect(UpdateNeed.bind(NeedToUpdate, amountToChangePerSecond * 5))
	add_child(timer)
	timer.start(5)

func UpdateNeed(NeedToUpdate:String, amountToChangeBy:float):
	var need = clampf(get(NeedToUpdate) + amountToChangeBy, SimulantSettings.MIN_NEED, SimulantSettings.MAX_NEED)
	set(NeedToUpdate, need)
	NeedUpdated.emit(NeedToUpdate, need)
