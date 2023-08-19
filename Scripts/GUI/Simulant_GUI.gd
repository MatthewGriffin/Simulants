extends Control

@onready var EnergyProgBar:ProgressBar = $GUI_VCont/GUI_HCont/SimulantNeeds_GUI/MainCont/NeedsCont/EnergyCont/EnergyProgressBar
@onready var HungerProgBar:ProgressBar = $GUI_VCont/GUI_HCont/SimulantNeeds_GUI/MainCont/NeedsCont/HungerCont/HungerProgressBar
@onready var SocialProgBar:ProgressBar = $GUI_VCont/GUI_HCont/SimulantNeeds_GUI/MainCont/NeedsCont/SocialCont/SocialProgressBar
@onready var FunProgBar:ProgressBar = $GUI_VCont/GUI_HCont/SimulantNeeds_GUI/MainCont/NeedsCont/FunCont/FunProgressBar
var _GameController:GameController

var EnergyTween:Tween
var HungerTween:Tween
var SocialTween:Tween
var FunTween:Tween

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
			if EnergyTween:
				EnergyTween.kill()
			EnergyTween = create_tween()
			EnergyTween.tween_property(EnergyProgBar, "value", value, 1)
		SimulantSettings.TYPE_HUNGER:
			if HungerTween:
				HungerTween.kill()
			HungerTween = create_tween()
			HungerTween.tween_property(HungerProgBar, "value", value, 1)
		SimulantSettings.TYPE_SOCIAL:
			if SocialTween:
				SocialTween.kill()
			SocialTween = create_tween()
			SocialTween.tween_property(SocialProgBar, "value", value, 1)
		SimulantSettings.TYPE_FUN:
			if FunTween:
				FunTween.kill()
			FunTween = create_tween()
			FunTween.tween_property(FunProgBar, "value", value, 1)
