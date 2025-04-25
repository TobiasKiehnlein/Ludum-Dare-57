extends Node

class _QueuedPackedScene:
	var pack: PackedScene
	var callback: Callable

class _LoadedScene:
	var scene: Node
	var callback: Callable

# Protected by _queue_mutex
var _queued_packed_scenes: Array[_QueuedPackedScene] = []
# Protected by _loaded_mutex
var _loaded_scenes: Array[_LoadedScene] = []

# Load scenes in a separate thread
var _thread: Thread
var _queue_mutex: Mutex
var _queue_semaphore: Semaphore
# Protected by _queue_mutex
var _exit_thread: bool = false

var _loaded_mutex: Mutex

func _ready() -> void:
	_queue_mutex = Mutex.new()
	_queue_semaphore = Semaphore.new()
	_exit_thread = false
	
	_loaded_mutex = Mutex.new()

	_thread = Thread.new()
	_thread.start(_thread_function)

func _process(delta: float) -> void:
	_loaded_mutex.lock()
	for loaded_scene in _loaded_scenes:
		if ! loaded_scene.callback.is_valid():
			loaded_scene.scene.queue_free()
			push_warning("SceneLoader: Unable to return loaded scene. Callback invalid")
			continue
		loaded_scene.callback.call(loaded_scene.scene)
	_loaded_scenes = []
	_loaded_mutex.unlock()

func _thread_function():
	while true:
		_queue_semaphore.wait() # Wait until posted.

		_queue_mutex.lock()
		var should_exit = _exit_thread # Protect with Mutex.
		_queue_mutex.unlock()

		if should_exit:
			break

		_load_packed_scenes()

# Must only be called by thread_function
func _load_packed_scenes():
	var local_array: Array[_QueuedPackedScene]
	_queue_mutex.lock()
	local_array = _queued_packed_scenes
	_queued_packed_scenes = []
	_queue_mutex.unlock()
	
	for entry in local_array:
		var new_scene = entry.pack.instantiate()
		var loaded = _LoadedScene.new()
		loaded.scene = new_scene
		loaded.callback = entry.callback
		_loaded_mutex.lock()
		_loaded_scenes.append(loaded)
		_loaded_mutex.unlock()

func load_packed_scene(pack: PackedScene, callback: Callable):
	var task = _QueuedPackedScene.new()
	task.callback = callback
	task.pack = pack
	_queue_mutex.lock()
	_queued_packed_scenes.append(task)
	_queue_mutex.unlock()
	_queue_semaphore.post()

func _exit_tree():
	# Set exit condition to true.
	_queue_mutex.lock()
	_exit_thread = true
	_queue_mutex.unlock()

	# Unblock by posting.
	_queue_semaphore.post()

	# Wait until it exits.
	_thread.wait_to_finish()
