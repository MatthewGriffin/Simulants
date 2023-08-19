extends Base_Interactable

class_name Interactable_PlateOfFood

func Setup(simulant:Simulant):
	super(simulant)
	Activities = [
		Activity.new().Setup("Eat plate of food", SimulantSettings.TYPE_HUNGER, [
			simulant.SetTarget.bind(Node_InteractPoints[randi() % Node_InteractPoints.size()])
			,simulant.AtTarget
			,simulant._SimulantNeeds.UpdateNeed.bind(SimulantSettings.TYPE_HUNGER, FoodDict.FOOD_SNACK)
			,queue_free
		], FoodDict.FOOD_SNACK)
	]
