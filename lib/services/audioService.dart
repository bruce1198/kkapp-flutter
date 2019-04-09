import 'package:audioplayers/audioplayers.dart';
import '../music.dart';

class PlayAudioInBackground{
	static Music _music = Music(-1, '未選擇歌曲', '', '', 0);
	static AudioPlayer player = AudioPlayer();
	static Duration duration = Duration(seconds: 0);
	static Duration position = Duration(seconds: 0);
	static bool _isPlaying = false;
	static int _selected = -1;
	static play(Music m, int index) async{
		await player.stop();
		_isPlaying = true;
		player.onAudioPositionChanged.listen((d){
			position = d;
			if(position == getDuration()) {
				release();
			}
      	});
		await player.play(m.url);
		_music = m;
		_selected = index;
	}
	static getMusicInfo() {
		if(_music == null) {
			return Music(-1, '未選擇歌曲', '', '', 0);
		}
		return _music;
	}
	static getPosition() {
		return position;
	}
	static getDuration() {
		return Duration(seconds: _music.duration);
	}
	static getIsPlaying() {
		return _isPlaying;
	}
	static pause() async{
		int result = await player.pause();
		if(result == 1) {
			_isPlaying = false;
		}
	}
	static resume() async{
		int result = await player.resume();
		if(result == 1) {
			_isPlaying = true;
		}
	}
	static seek(Duration d) async{
		int result = await player.seek(d);
		if(result == 1) {
			position = d;
		}
	}
	static release() async{
		int result = await player.release();
		if(result == 1) {
			_isPlaying = false;
			position = Duration(seconds: 0);
			duration = Duration(seconds: 0);
			_music = Music(-1, '未選擇歌曲', '', '', 0);
			_selected = -1;
		}
	}
	static getSelected() {
		return _selected;
	}
}

