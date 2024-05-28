extends Resource
class_name TurretCollection

@export var turrets : Array[TurretData]

func getTurretDataByName(inName : String) -> TurretData:
	for turretData in turrets:
		var name : String = turretData.name
		if inName == name:
			return turretData

	return null

