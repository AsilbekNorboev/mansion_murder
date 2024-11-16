extends Node2D

signal room_entered(room)
#global NPC value to detect who you've met
var NPC

func new_game():
	print("game start")
	$Audio.play()
	
