extends Node

class_name Base_Interactable

var Activities: Array[Activity] = []
var Node_InteractPoints:Array[Node] = []
var Targets:Array[Target] = []
var _Simulant:Simulant

@onready var InteractableMesh = $InteractableMesh

func Setup(_simulant:Simulant):
	_Simulant = _simulant
	Node_InteractPoints = $InteractionPoints.get_children()
	return
