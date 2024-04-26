@tool
extends EditorScript

var mode_disableplugin = false
var projectsettingfile_path = "res://project.godot"
var disabledaddonsfile_path = "res://disabledaddons.cfg"
func config_check_and_remove(config : ConfigFile, disabledconfig : ConfigFile, section, key):
	if config.has_section_key(section, key):
		disabledconfig.set_value(section, key, config.get_value(section, key))
		config.set_value(section, key, null)
		mode_disableplugin = true

func get_array_of_comments(projectsettingtext : String) -> Array:
	var settingtextarray = projectsettingtext.split("\n")
	var projectsettingcomment : Array
	for line in settingtextarray:
		if line.begins_with(";"):
			projectsettingcomment.append(line)
	return projectsettingcomment

func open_file_and_get_text(filepath : String) -> String:
	var file = FileAccess.open(filepath, FileAccess.READ)
	var textfromfile : String = file.get_as_text()
	file.close()
	return textfromfile

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var projectsettingtext = open_file_and_get_text(projectsettingfile_path) # res://project.godot # res://project.godot_test.cfg
	var projectsettingcomment = get_array_of_comments(projectsettingtext)
	
	var projectconfig = ConfigFile.new()
	var disabledconfig = ConfigFile.new()
	projectconfig.parse(projectsettingtext)
	config_check_and_remove(projectconfig, disabledconfig, "autoload", "DiscordSDKLoader")
	config_check_and_remove(projectconfig, disabledconfig, "autoload", "MyDiscordRPC")
	config_check_and_remove(projectconfig, disabledconfig, "editor_plugins", "enabled")
	
	var configtext
	if mode_disableplugin:
		disabledconfig.save(disabledaddonsfile_path)
		push_warning("Active addons now deactivated. Please reload the project on Project > Reload Current Project")
	else:
		projectconfig.load(projectsettingfile_path)
		disabledconfig.load(disabledaddonsfile_path)
		for section in disabledconfig.get_sections():
			for key in disabledconfig.get_section_keys(section):
				projectconfig.set_value(section, key, disabledconfig.get_value(section, key))
				disabledconfig.set_value(section, key, null)
		disabledconfig.save(disabledaddonsfile_path)
		push_warning("Inactive addons now reactivated. Please reload the project on Project > Reload Current Project")
		
	configtext = projectconfig.encode_to_text()
	var projectsettingfile = FileAccess.open(projectsettingfile_path, FileAccess.WRITE)
	for line in projectsettingcomment:
		projectsettingfile.store_line(line)
	projectsettingfile.store_line("") # extra empty line
	projectsettingfile.store_string(configtext)
	projectsettingfile.close()
