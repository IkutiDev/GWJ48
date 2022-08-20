extends Node

var songList = {
	2 : preload("res://Resouces/Music/MUS_Combat_Exploration_Variant.ogg"), # fight
	1 : preload("res://Resouces/Music/MUS_Music_Pad_and_Melody.ogg"), # rest
	0 : preload("res://Resouces/Music/MUS_Short_Loop.ogg") # main menu
	
}

var musicFolderPath = "res://Resouces/Music/"

var current_song_id : int = -1

func _ready():
	randomize()
#	var musicFolder = Directory.new()
#	if musicFolder.open(musicFolderPath) == OK :
#		musicFolder.list_dir_begin()
#		var songName = musicFolder.get_next()
#		var ID = 0
#		while songName != "":
#			if !musicFolder.current_is_dir() and !songName.ends_with("import"):
#				songList[ID] = songName
#				$CanvasLayer/OptionButton.add_item(songName,ID)
#				ID += 1
#			songName = musicFolder.get_next()
	pass

func play_song(ID):
	if ID == current_song_id:
		return
	var nextSong = songList[ID]
	current_song_id = ID
	if $MusicPlayer1.playing:
		$MusicPlayer2.stream = nextSong
		$DJ.play("Play2")
		$MusicPlayer2.play(randi() % int(max(0,$MusicPlayer2.stream.get_length()-10)))
	else:
		$MusicPlayer1.stream = nextSong
		$DJ.play("Play1")
		$MusicPlayer1.play(randi() % int(max(0,$MusicPlayer1.stream.get_length()-10)))

	
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
