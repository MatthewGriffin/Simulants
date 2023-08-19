extends Base_Interactable

class_name Interactable_FridgeFreezer

func Setup(simulant:Simulant):
	super(simulant)
	Activities = [
		Activity.new().Setup("Get Snack", SimulantSettings.TYPE_HUNGER, [
			simulant.SetTarget.bind(Node_InteractPoints[0])
			,simulant.AtTarget
			,simulant._SimulantNeeds.UpdateNeed.bind(SimulantSettings.TYPE_HUNGER, FoodDict.FOOD_SNACK)
		], FoodDict.FOOD_SNACK)
		,Activity.new().Setup("Get Meal", SimulantSettings.TYPE_HUNGER, [
			simulant.SetTarget.bind(Node_InteractPoints[0])
			,simulant.AtTarget
			,simulant._SimulantNeeds.UpdateNeed.bind(SimulantSettings.TYPE_HUNGER, FoodDict.FOOD_MEAL)
		], FoodDict.FOOD_MEAL)
	]
