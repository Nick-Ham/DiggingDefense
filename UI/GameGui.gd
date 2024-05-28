extends CanvasLayer
class_name GameGui

@export_category("Local")
@export var startWaveButton : Button
@export var remainingWavesCount : Label
@export var oreCount : Label
@export var healthBar : Range

signal start_wave

var waveManager : WaveManager = null
var walletManager : WalletManager = null

func _ready() -> void:
	assert(startWaveButton)
	assert(remainingWavesCount)

	var parentLevel : Level = get_parent() as Level
	assert(parentLevel, "Gamegui not childed to a level. Incorrect usage.")

	bindToMenuEvents()

func bindToMenuEvents() -> void:
	Util.safeConnect(startWaveButton.pressed, _on_start_wave_pressed)

func updateOreCount() -> void:
	oreCount.text = str(walletManager.getOreCount())

func updateWavesCount() -> void:
	var wavesCount : int = waveManager.getRemainingWaves().size()
	if wavesCount <= 0:
		startWaveButton.disabled = true

	remainingWavesCount.text = str(wavesCount)

func _on_start_wave_pressed() -> void:
	start_wave.emit()

func injectWaveManager(inWaveManager : WaveManager) -> void:
	waveManager = inWaveManager
	Util.safeConnect(waveManager.remaining_waves_updated, _on_remaining_waves_updated)
	updateWavesCount()

func injectWalletManager(inWalletManager : WalletManager) -> void:
	walletManager = inWalletManager
	Util.safeConnect(walletManager.ore_count_updated, _on_ore_count_updated)
	updateOreCount()

func _on_remaining_waves_updated(inRemainingWaves : int) -> void:
	updateWavesCount()

func _on_ore_count_updated(inNewTotal : int) -> void:
	updateOreCount()
