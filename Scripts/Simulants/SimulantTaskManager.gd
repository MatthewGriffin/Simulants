extends Node
class_name SimulantTaskManager

signal TasksUpdated

var _Simulant:Simulant
var _GameController:GameController
var Tasks:Array[Dictionary]
var TaskTimer:Timer = Timer.new()

func Setup(simulant:Simulant, gameManager):
	TaskTimer.timeout.connect(CheckNeeds)
	add_child(TaskTimer)
	TaskTimer.start(5)
	TasksUpdated.connect(PerformTasks)
	
	_Simulant = simulant
	_GameController = gameManager

func CheckNeeds():
	CheckNeed("Hunger", _Simulant._SimulantNeeds.Hunger)
	CheckNeed("Energy", _Simulant._SimulantNeeds.Energy)
	CheckNeed("Social", _Simulant._SimulantNeeds.Social)
	CheckNeed("Fun", _Simulant._SimulantNeeds.Fun)

func CheckNeed(need:String, value:float):
	#if need is critical 
	if (Tasks.is_empty() || !Tasks[0].keys()[0]) && (need == SimulantSettings.TYPE_HUNGER && value <= SimulantSettings.NEED_CRITICAL) || (need == SimulantSettings.TYPE_ENERGY && value <= SimulantSettings.NEED_CRITICAL) || (need == SimulantSettings.TYPE_SOCIAL && value <= SimulantSettings.NEED_CRITICAL) || (need == SimulantSettings.TYPE_FUN && value <= SimulantSettings.NEED_CRITICAL):
		#add critical task to start of list
		var bestAction = GetBestActionForNeed(need, value)
		if bestAction != null:
			Tasks.insert(0, { true: bestAction })
			TasksUpdated.emit(Tasks)
	#if nothing to do 
	elif Tasks.is_empty() && value <= 75:
		#get lowest need and add non critical task list
		var bestAction = GetBestActionForNeed(need, _Simulant._SimulantNeeds.get(need))
		if !bestAction.Tasks.is_empty():
			Tasks.append({ false: bestAction })
			TasksUpdated.emit(Tasks)

func GetBestActionForNeed(need:String, value:float)->Activity:
	var bestActivity:Activity = Activity.new().Setup("","",[],-999)
	var bestInteractable:Base_Interactable
	var needFufillAmount = SimulantSettings.MAX_NEED - value
	var interactables = _GameController.GetInteractables()
	for interactable in interactables:
		for activity in interactable.Activities:
			if activity.Active:
				#if activity value is closer to amount needed e.g A snack is better than a main meal if not that hungry 
				if activity.Need == need && abs(needFufillAmount - activity.Value) < abs(needFufillAmount - bestActivity.Value):
					bestActivity = activity
					bestInteractable = interactable
				#if more than one activity provides the same value then get closest
				elif activity.Need == need && abs(needFufillAmount - activity.Value) == abs(needFufillAmount - bestActivity.Value):
					var oldDistance = abs(_Simulant.position.distance_to(bestInteractable.position))
					var newDistance = abs(_Simulant.position.distance_to(interactable.position))
					if newDistance < oldDistance:
						bestActivity = activity
						bestInteractable = interactable
	return bestActivity
	
func PerformTasks(tasks:Array):
	for task in tasks:
		for activityTask in task.values()[0].Tasks:
			if activityTask is Signal:
				await activityTask
			else:
				await activityTask.call()
		tasks.remove_at(tasks.find(task))

