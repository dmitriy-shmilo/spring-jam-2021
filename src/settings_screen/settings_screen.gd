extends Control


const KeyBindingButtonScene = preload("res://settings_screen/keybinding_button.tscn")
const KeyBindingLabelScene = preload("res://settings_screen/keybinding_label.tscn")

onready var _keybindings_grid = $"VBoxContainer/PanelContainer/TabContainer/Key Bindings/GridContainer"
onready var _keybinding_popup = $KeyBindingPopup
onready var _master_volume_slider = $"VBoxContainer/PanelContainer/TabContainer/Sound Settings/MasterVolume/VolumeSlider"
onready var _sfx_volume_slider = $"VBoxContainer/PanelContainer/TabContainer/Sound Settings/SfxVolume/VolumeSlider"
onready var _speech_volume_slider = $"VBoxContainer/PanelContainer/TabContainer/Sound Settings/SpeechVolume/VolumeSlider"
onready var _music_volume_slider = $"VBoxContainer/PanelContainer/TabContainer/Sound Settings/MusicVolume/VolumeSlider"

var _current_binding_button: KeyBindingButton = null

func _ready():
	_prepare_keybindings()
	_prepare_volume()


func _prepare_volume():
	_master_volume_slider.value = Settings.master_volume
	_speech_volume_slider.value = Settings.speech_volume
	_sfx_volume_slider.value = Settings.sfx_volume
	_music_volume_slider.value = Settings.music_volume


func _prepare_keybindings():
	var actions = InputMap.get_actions()
	for action in actions:
		if action.begins_with("ui_") or action.begins_with("system_"):
			continue;
		var label = KeyBindingLabelScene.instance()
		label.text = action
		var button = KeyBindingButtonScene.instance()
		button.action = action
		button.connect("pressed", \
			self, \
			"_on_KeyBindingButton_keybind_requested",
			[button])
		_keybindings_grid.add_child(label)
		_keybindings_grid.add_child(button)

func _on_MasterVolumeSlider_value_changed(value):
	Settings.master_volume = value


func _on_MusicVolumeSlider_value_changed(value):
	Settings.music_volume = value


func _on_SfxVolumeSlider_value_changed(value):
	Settings.sfx_volume = value


func _on_SpeechVolumeSlider_value_changed(value):
	Settings.speech_volume = value


func _on_BackButton_pressed():
	Settings.save_settings()
	get_tree().change_scene("res://title_screen/title_screen.tscn")


func _on_KeyBindingButton_keybind_requested(sender: KeyBindingButton):
	_current_binding_button = sender
	_keybinding_popup.action = sender.action
	_keybinding_popup.popup_centered()


func _on_KeybindingCancelButton_pressed():
	_keybinding_popup.hide()
	_current_binding_button = null


func _on_KeyBindingPopup_action_remapped(action, event):
	InputMap.action_erase_events(action)
	if event != null:
		InputMap.action_add_event(action, event)

	_current_binding_button.refresh_label()
	_keybinding_popup.hide()

