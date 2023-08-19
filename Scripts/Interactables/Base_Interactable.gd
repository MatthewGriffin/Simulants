extends Node

class_name Base_Interactable

var Activities: Array[Activity] = []
@onready var Node_InteractPoints:Array[Node] = []

func Setup(_simulant:Simulant):
	Node_InteractPoints = $InteractionPoints.get_children()
	return
