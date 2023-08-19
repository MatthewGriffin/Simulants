extends Node

class_name Activity

var Name:String = ""
var Need:String = ""
var Tasks:Array = []
var Value:float = 0

func Setup(activityName:String, need:String, tasks:Array, value:float) -> Activity:
	Name= activityName
	Need = need
	Tasks = tasks
	Value = value
	return self
