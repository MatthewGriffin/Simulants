extends Node3D
class_name	GameController

@onready var CurrentSimulant:Simulant = $Simulants/Simulant
@onready var Node_Interactables:Node3D = $Geometry/NavigationRegion3D/Interactables
@onready var GUI_Scene = preload("res://GUI/Simulants/Simulant_GUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentSimulant.Setup(self)
	var GUI = GUI_Scene.instantiate()
	add_child(GUI)
	GUI.Setup(self)
	SetupInteractables()

func SetupInteractables():
	var interactables = GetInteractables()
	for interactable in interactables:
		interactable.Setup(CurrentSimulant)

func GetInteractables()->Array[Base_Interactable]:
	var interactables: Array[Base_Interactable] = []
	var _varients = Node_Interactables.get_children()
	#Only return child elements are inherited from Base_Interactable
	for interactable in _varients:
		if interactable is Base_Interactable:
			interactables.append(interactable)
	return interactables
