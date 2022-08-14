extends Node

var songList = {}

var musicFolderPath = "res://Resouces/Music/"

func _ready():
	var musicFolder = Directory.new()
	if musicFolder.open(musicFolderPath) == OK :
		musicFolder.list_dir_begin()
		var songName = musicFolder.get_next()
		var ID = 0
		while songName != "":
			if !musicFolder.current_is_dir() and !songName.ends_with("import"):
				songList[ID] = songName
				$CanvasLayer/OptionButton.add_item(songName,ID)
				ID += 1
			songName = musicFolder.get_next()
	pass

func play_song(ID):
	var nextSong = load(musicFolderPath+songList[ID])
	if $MusicPlayer1.playing:
		$MusicPlayer2.stream = nextSong
		$DJ.play("Play2")
		$MusicPlayer2.play(randi()%20)
	else:
		$MusicPlayer1.stream = nextSong
		$DJ.play("Play1")
		$MusicPlayer1.play(randi()%20)
	print($MusicPlayer1.volume_db,$MusicPlayer2.volume_db)
	
	pass


func _on_OptionButton_item_selected(index):
	play_song(index)

	pass # Replace with function body.


func _on_DJ_animation_finished(anim_name):
	if anim_name == "Play1":
		$MusicPlayer2.stream = null
	else:
		$MusicPlayer1.stream = null
	pass # Replace with function body.
