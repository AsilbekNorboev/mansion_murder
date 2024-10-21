extends Node2D

signal room_entered(room)

func new_game():
	print("Game start")
	$Audio.play()
