extends Node
class_name Target

var TargetObject: Object
var InteractPoint:Node

func Setup(target:Object, interactPoint:Node)->Target:
	TargetObject = target
	InteractPoint = interactPoint
	return self
