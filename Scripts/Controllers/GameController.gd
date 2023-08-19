extends Node3D
class_name	GameController

@onready var CurrentSimulant:Simulant = $Simulants/Simulant
@onready var Node_Interactables:Node3D = $Geometry/NavigationRegion3D/Interactables
@onready var GUI_Scene = preload("res://GUI/Simulants/Simulant_GUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentSimulant.Setup()
	var GUI = GUI_Scene.instantiate()
	add_child(GUI)
	GUI.Setup(self)
