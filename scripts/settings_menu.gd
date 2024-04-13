extends Control

@onready var list = $SettingsList
@onready var titlelabel = $SettingsList/TitleLabel
@onready var noticelabel = $SettingsList/NoticeLabel
@onready var buttonlist = $SettingsList/ButtonList

func _ready():
	var currentwindow = get_window()
	currentwindow.set_size(Vector2i(400,600))
	self.set_size(Vector2i(400,600))
	
	var config = ConfigFile.new()
	
	# too lazy to check for errors
	config.load("user://limbosave.cfg")
			
	for setting_name in VariableKeeper.main_saved_values:
		var setting_value = config.get_value("settings", setting_name)
		
		## for debug
		#var nametext = "var name: " + setting_name + " | value: "
		#print(nametext + str(setting_value))
		
		if setting_value is float:
			var new_floatsetting = load("res://scenes/float_setting.tscn").instantiate()
			new_floatsetting.get_node("Label").set_text(setting_name)
			new_floatsetting.get_node("SpinBox").value = setting_value
			list.add_child(new_floatsetting)
			new_floatsetting.add_to_group("floatsetting")
		elif setting_value is bool:
			var new_checkbox = CheckBox.new()
			new_checkbox.set_text(setting_name)
			new_checkbox.set_pressed(setting_value)
			list.add_child(new_checkbox)
		list.move_child(noticelabel, -1)
		list.move_child(buttonlist, -1)

func _on_discard_pressed():
	get_tree().quit()

func _on_save_pressed():
	var config = ConfigFile.new()
	for node in list.get_children():
		if node.is_in_group("floatsetting"):
			config.set_value("settings", node.get_node("Label").get_text(), node.get_node("SpinBox").get_value())
		elif node is CheckBox:
			config.set_value("settings", node.get_text(), node.is_pressed())
	config.save("user://limbosave.cfg")
	print("New config saved")
	get_tree().quit()
