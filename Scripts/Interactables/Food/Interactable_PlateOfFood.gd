extends Base_Interactable
class_name Interactable_PlateOfFood

func Setup(simulant:Simulant):
	super(simulant)
	Activities = [
		Activity.new().Setup("Eat plate of food", SimulantSettings.TYPE_HUNGER, [
			simulant.SetTarget.bind(Node_InteractPoints.pick_random())
			,simulant.AtTarget
			,simulant._SimulantNeeds.UpdateNeedOverTime.bind(SimulantSettings.TYPE_HUNGER, ActionDict.HUNGER_SNACK, SimulantSettings.NEED_UPDATE_RATE)
			,queue_free
		], ActionDict.HUNGER_SNACK)
	]
