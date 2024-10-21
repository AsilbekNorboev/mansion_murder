extends Node2D

signal room_entered(room)

func new_game():
	print("game start")
	$Audio.play()
	
