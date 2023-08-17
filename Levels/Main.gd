extends Node3D

@onready var Simulant = $Simulants/Simulant
@onready var Destination = $Destination

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.timeout.connect(Simulant.Setup.bind(Destination))
	add_child(timer)
	timer.start(5)
