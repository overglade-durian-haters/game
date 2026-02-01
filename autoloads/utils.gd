extends Node


func format_timestamp(time: float):
	var result = ""
	if time > 3600:
		result += str(floori(time / 3600)) + ":"
		time = fmod(time, 3600)
	var minutes = floori(time / 60)
	if minutes < 10:
		result += "0"
	result += str(minutes) + ":"
	time = fmod(time, 60)
	if time < 10:
		result += "0"
	result += str(floori(time)) + "."
	time = fmod(time, 1)
	if floori(time * 100) < 10:
		result += "0"
	result += str(floori(time * 100))
	return result
