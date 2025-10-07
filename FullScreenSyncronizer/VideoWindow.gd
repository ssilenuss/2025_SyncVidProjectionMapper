extends Window

var file : VideoStreamTheora
var player : VideoStreamPlayer

func _ready() -> void:
	player = VideoStreamPlayer.new()
	if file:
		#player data
		
		player.set_stream(file)
	player.set_expand(true)
	player.set_autoplay(true)
	$VideoHolder.add_child(player)
		var video_size : Vector2 = player.get_video_texture().get_size()
	size = video_size

	
	#window data
	title = "test"

	visible = true
	position = Vector2(800,800)

func _process(delta: float) -> void:
	if not player.is_playing():
		player.play()
	
func _on_close_requested() -> void:
	self.queue_free()
