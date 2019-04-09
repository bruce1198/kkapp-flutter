import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../services/audioService.dart';
import '../music.dart';

class MusicSelect extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return MusicSelectState();
	}
}

class MusicSelectState extends State<MusicSelect>{
	@override
  	Widget build(BuildContext context) {
		//fetchMusic();
    	return FutureBuilder<List<Music>>(
			future: fetchMusic(),
			builder: (context, snapshot) {
          		if (snapshot.hasError) print(snapshot.error);

          	return snapshot.hasData
              	? MusicsList(musics: snapshot.data)
              	: Center(child: CircularProgressIndicator());
        	},
		);
  	}
}

Future<List<Music>> fetchMusic() async{
    var url = "http://140.114.207.97/kkapp/musics/apis/info/outputFormat.php";
    final response = await http.get(url+"?user=bruce1198&kind=all");
    print(response.body);
    return compute(parseMusics, response.body);
}

List<Music> parseMusics(String response) {
	final parsed = json.decode(response).cast<Map<String, dynamic>>();
	//print(parsed);
	return parsed.map<Music>((json) => Music.fromJson(json)).toList();
}

class MusicsListState extends State<MusicsList> {
  	final List<Music> musics;

  	MusicsListState({Key key, this.musics});

  	int _select;

	@override
	void initState() {
		super.initState();
		_select = -1;
		_getSelect();
	}

  	_getSelect() {
		Timer.periodic(new Duration(milliseconds: 10), (timer) {
			if(mounted) {
				setState(() {
					_select = PlayAudioInBackground.getSelected();
				});
			}
		});
	}

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
		itemCount: musics.length,
		itemBuilder: (context, index) {
			return ListTileTheme(
					selectedColor: Colors.blue,
					child: ListTile(
						title: Text(musics[index].name),
						subtitle: Text(musics[index].singer),
						onTap: () {
							PlayAudioInBackground.play(musics[index], index);
						},
						selected: index == _select,
					),
				);
			},
		);
	}
}

class MusicsList extends StatefulWidget {
	final List<Music> musics;
	MusicsList({Key key, this.musics});
	@override
	State<StatefulWidget> createState() {
		return MusicsListState(musics: musics);
	}
}
