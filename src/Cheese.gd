extends "res://src/Cog.gd"

func collected(body):
	.collected(body)
	# i dont know bruh
	var healamount = floor(body.get(varname) / 10)
	if healamount > 0:
		body.set(varname, 0)
		body.set('health', min(body.get('health') + healamount, 3))
