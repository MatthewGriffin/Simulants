extends Base_Interactable

class_name Interactable_FridgeFreezer

func Setup(simulant:Simulant):
	
	Activities = [
		Activity.new().Setup("Get Snack", SimulantSettings.TYPE_HUNGER, [
			simulant.SetTarget.bind(self)
			,simulant.AtTarget
			,simulant.SimulantNeeds.UpdateNeed.bind(SimulantSettings.TYPE_HUNGER, SimulantSettings.SNACK_VALUE)
		], SimulantSettings.SNACK_VALUE)
	]
