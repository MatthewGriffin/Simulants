extends Base_Interactable
class_name Interactable_Bed

func Setup(simulant:Simulant):
	super(simulant)
	Targets = [
		Target.new().Setup(self, Node_InteractPoints.pick_random()),
		Target.new().Setup(self, Node_InteractPoints[randi_range(4,5)])
	]
	Activities = [
		Activity.new().Setup("Sit", SimulantSettings.TYPE_ENERGY, [
			simulant.SetTarget.bind(Targets[0])
			,simulant.SetCanWalk.bind(true)
			,simulant.AtTarget
			,simulant.SetCanWalk.bind(false)
			,simulant._SimulantNeeds.SetNeedTarget.bind(SimulantSettings.TYPE_ENERGY, ActionDict.ENERGY_SIT)
		], ActionDict.ENERGY_SIT, false)
		,Activity.new().Setup("Go to bed", SimulantSettings.TYPE_ENERGY, [
			simulant.SetTarget.bind(Targets[1])
			,simulant.SetCanWalk.bind(true)
			,simulant.AtTarget
			,simulant.SetCanWalk.bind(false)
			,simulant.StateMachine.travel.bind("GetInBed")
			,simulant.SetAnimPlaying.bind(true)
			,simulant.AnimTree.animation_finished
			,simulant._SimulantNeeds.PauseNeedTimer.bind(SimulantSettings.TYPE_ENERGY, true)
			,simulant._SimulantNeeds.SetNeedTarget.bind(SimulantSettings.TYPE_ENERGY, ActionDict.ENERGY_SLEEP)
			,simulant._SimulantNeeds.NeedFulfilled
			,simulant._SimulantNeeds.PauseNeedTimer.bind(SimulantSettings.TYPE_ENERGY, false)
			,simulant.StateMachine.travel.bind("GetOutOfBed")
			,simulant.AnimTree.animation_finished
			,simulant.ResetTarget
			,simulant.StateMachine.travel.bind("Walk")
			,simulant.SetAnimPlaying.bind(false)
		], ActionDict.ENERGY_SLEEP)
	]
