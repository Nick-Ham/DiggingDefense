extends Node

signal hq_destroyed(level : Level, hq : HQ)

signal wave_manager_state_changed(manager : WaveManager, newWaveState : WaveManager.WAVE_STATE)

signal start_wave

signal spawn_group_spawning_completed

signal wave_completed
