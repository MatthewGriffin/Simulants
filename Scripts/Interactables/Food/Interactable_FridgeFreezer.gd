extends Base_Interactable
class_name Interactable_FridgeFreezer

func Setup(simulant:Simulant):
	super(simulant)
	Activities = [
		Activity.new().Setup("Eat snack", SimulantSettings.TYPE_HUNGER, [
			simulant.SetTarget.bind(Node_InteractPoints[0])
			,simulant.AtTarget
			,simulant._SimulantNeeds.UpdateNeedOverTime.bind(SimulantSettings.TYPE_HUNGER, ActionDict.HUNGER_SNACK, SimulantSettings.NEED_UPDATE_RATE)
		], ActionDict.HUNGER_SNACK)
		,Activity.new().Setup("Eat meal", SimulantSettings.TYPE_HUNGER, [
			simulant.SetTarget.bind(Node_InteractPoints[0])
			,simulant.AtTarget
			,simulant._SimulantNeeds.UpdateNeedOverTime.bind(SimulantSettings.TYPE_HUNGER, ActionDict.HUNGER_MEAL, SimulantSettings.NEED_UPDATE_RATE)
		], ActionDict.HUNGER_MEAL)
	]
