extends Control

@onready var EnergyProgBar:ProgressBar = $GUI_VCont/GUI_HCont/SimulantNeeds_GUI/MainCont/NeedsCont/EnergyCont/EnergyProgressBar
@onready var HungerProgBar:ProgressBar = $GUI_VCont/GUI_HCont/SimulantNeeds_GUI/MainCont/NeedsCont/HungerCont/HungerProgressBar
@onready var SocialProgBar:ProgressBar = $GUI_VCont/GUI_HCont/SimulantNeeds_GUI/MainCont/NeedsCont/SocialCont/SocialProgressBar
@onready var FunProgBar:ProgressBar = $GUI_VCont/GUI_HCont/SimulantNeeds_GUI/MainCont/NeedsCont/FunCont/FunProgressBar
var _GameController:GameController

func Setup(gameControler:GameController):
	_GameController = gameControler
	_GameController.CurrentSimulant._SimulantNeeds.NeedUpdated.connect(UpdateLocNeeds)
	InitNeedsGUI()

func InitNeedsGUI():
	EnergyProgBar.value = _GameController.CurrentSimulant._SimulantNeeds.Energy
	HungerProgBar.value = _GameController.CurrentSimulant._SimulantNeeds.Hunger
	SocialProgBar.value = _GameController.CurrentSimulant._SimulantNeeds.Social
	FunProgBar.value = _GameController.CurrentSimulant._SimulantNeeds.Fun

func UpdateLocNeeds(need:String, value:float):
	match need:
		SimulantSettings.TYPE_ENERGY:
			EnergyProgBar.value = value
		SimulantSettings.TYPE_HUNGER:
			HungerProgBar.value = value
		SimulantSettings.TYPE_SOCIAL:
			SocialProgBar.value = value
		SimulantSettings.TYPE_FUN:
			FunProgBar.value = value
