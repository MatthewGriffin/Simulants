extends Node

class_name Activity

var Name:String = ""
var Need:String = ""
var Tasks:Array = []
var Value:float = 0
var Active = true

func Setup(activityName:String, need:String, tasks:Array, value:float, active:bool = true) -> Activity:
	Name= activityName
	Need = need
	Tasks = tasks
	Value = value
	Active = active
	return self
