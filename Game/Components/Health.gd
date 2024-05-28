extends Node
class_name Health

@export_category("Config")
@export_range(1, 9999) var maxHealth : int = 0

var currentHealth : int = 0

signal health_changed(inHealth : int)
signal health_depleted

func _ready() -> void:
	currentHealth = maxHealth
	health_changed.emit(currentHealth)

func takeDamage(inDamage : int) -> void:
	currentHealth = clampi(currentHealth - inDamage, 0, maxHealth)
	health_changed.emit(inDamage)

	if currentHealth <= 0:
		health_depleted.emit()

func getCurrentHealth() -> int:
	return currentHealth

func getMaxHealth() -> int:
	return maxHealth
