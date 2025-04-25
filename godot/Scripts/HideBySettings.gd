extends CanvasItem 

@export var visibleInSettings: bool

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = ! visibleInSettings
	
	GameManager.settings_opened.connect(_handle_settings_opened)

func _handle_settings_opened(open:bool):
	self.visible = open == visibleInSettings
	
