import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'myMusic.dart';
import 'dicover.dart';
import 'setting.dart';
import 'more.dart';
import 'item/drawer.dart';
import 'services/audioService.dart';
import 'music.dart';
import 'login.dart';

void main() => runApp(MyApp());

class User {
	int id;
	String name;
	String email;
	User(this.id, this.name, this.email);
	factory User.fromJson(Map<String, dynamic> json) {
		return User(
			json['id'] as int,
			json['name'] as String,
			json['email'] as String);
  	}
}

class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'kkApp',
			home: MainPage(),
			theme: ThemeData(
				brightness: Brightness.light,
				primaryColor: Colors.white,
				accentColor: Colors.blue[600],
				textSelectionHandleColor: Colors.blue
			),
		);
	}
}

class MainPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return MainPageState();
	}
}

class MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{

	RubberAnimationController _controller;

	ScrollController _scrollController = ScrollController();

	final _drawerItems = [DrawerItem('我的音樂庫', Icons.queue_music), DrawerItem('發現', Icons.scatter_plot),
						DrawerItem('設定', Icons.settings), DrawerItem('更多', Icons.more_horiz),];
	final _title = ['我的音樂庫', '發現', '設定', '更多'];
	int _selectedDrawerIndex = 0;

	Music _music;
	Duration _duration;
	Duration _position;
	double _value;
	bool _isPlaying;
	bool _hasSong;
	int _sheetType;
	User _user;

	_getDrawerItemWidget(int pos) {
		switch (pos) {
		case 0:
			return new MyMusic();
		case 1:
			return new DiscoverPage();
		default:
		}
	}
	_onSelectItem(int index) {
		switch(index) {
			case 0:
				setState(() => _selectedDrawerIndex = index);
				Navigator.of(context).pop();
				break;
			case 1:
				setState(() => _selectedDrawerIndex = index);
				Navigator.of(context).pop();
				break;
			case 2:
				Navigator.of(context).pop();
				Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
				break;
			case 3:
				Navigator.of(context).pop();
				Navigator.push(context, MaterialPageRoute(builder: (context) => MorePage()));
				break;
		}
	}

	_getInfo() {
		Timer.periodic(new Duration(milliseconds: 30), (timer) {
			//print(_value);
			if(mounted) {
				setState(() {
					_music = PlayAudioInBackground.getMusicInfo();
					_duration = Duration(seconds:_music.duration);
					_position = PlayAudioInBackground.getPosition();
					_value = _position.inSeconds.toDouble()/_duration.inSeconds.toDouble();
					_isPlaying = PlayAudioInBackground.getIsPlaying();
					_hasSong = _music.id==-1? false:true;
					print(_hasSong);
					_controller.setVisibility(_hasSong);
				});
			}
		});
	}
	myFormatter(Duration d) {
		int seconds = d.inSeconds;
		int hour = seconds~/3600;
		int minute = (seconds%3600)~/60;
		int second = seconds%60;
		String h = hour>9? hour.toString(): '0' + hour.toString();
		String m = minute>9? minute.toString(): '0' + minute.toString();
		String s = second>9? second.toString(): '0' + second.toString();
		if(h!='00') {
			return h+':'+m+':'+s;
		}
		else
			return m+':'+s;
	}

	@override
  	void initState() {
		super.initState();
		_user = User(-1, '', '');
		_music = Music(-1, '未選擇歌曲', '', '', 0);
		_duration = Duration(seconds: 0);
		_position = Duration(seconds: 0);
		_hasSong = false;
		_sheetType = 1;
		_isPlaying = false;
		_controller = RubberAnimationController(
			vsync: this,
			lowerBoundValue: AnimationControllerValue(pixel: 70),
			upperBoundValue: AnimationControllerValue(percentage: 1),
			//dismissable: true,
			springDescription: SpringDescription.withDampingRatio(
				mass: 1,
				stiffness: Stiffness.LOW,
				ratio: DampingRatio.NO_BOUNCY
			),
			duration: Duration(milliseconds: 200)
		);
		_getInfo();
		_checkLogin();
  	}

	_checkLogin() async {
		final prefs = await SharedPreferences.getInstance();

		// Try reading data from the counter key. If it does not exist, return 0.
		final isLogin = prefs.getBool('isLogin') ?? false;
		final email = prefs.getString('email')?? '';
		if(!isLogin) {
			Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
					return LoginPage();
				}), 
				(Route<dynamic> route) => false
			);
		}
		else {
			print(email);
			await fetchData(email).then((response){
				setState(() => _user = response[0]);
			});
		}
	}

	Future<List<User>> fetchData(String email) async{
		final url = 'http://140.114.207.97/kkapp/users/apis/info/get_user_info.php';
		final response = await http.post(url,
			body: {
				'email' : email
			}
		);
		print(response.body);
		return compute(parseUser, response.body);
	}

	List<User> parseUser(String response) {
		final parsed = json.decode(response).cast<Map<String, dynamic>>();
		//print(parsed);
		return parsed.map<User>((json) => User.fromJson(json)).toList();
	}

	@override
  	Widget build(BuildContext context) {
		
		var drawerOptions = <Widget>[];
		drawerOptions.add(
            DrawerHeader(
              	child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: <Widget>[
						Container(
							width: 60.0,
							height: 60.0,
							decoration: new BoxDecoration(
								shape: BoxShape.circle,
								image: new DecorationImage(
									fit: BoxFit.fill,
									image: new NetworkImage(
										'http://140.114.207.97/kebsite/image/logo.png')
								)
							)
						),
						Text(_user.name),
						Text(_user.email)
					],
				),
              	decoration: BoxDecoration(
                	color: Colors.blue[200],
              	),
            ),
		);
		for (var i = 0; i < _drawerItems.length; i++) {
			var d = _drawerItems[i];
			drawerOptions.add(
				new ListTileTheme(
					selectedColor: Colors.blue,
					child: ListTile(
						leading: new Icon(d.icon),
						title: new Text(d.title),
						selected: i == _selectedDrawerIndex,
						onTap: () => _onSelectItem(i),
					),
				)
			);
		}
		return Scaffold(
			drawer: Drawer(
				child: ListView(
					padding: EdgeInsets.zero,
					children: drawerOptions,
				)
			),
			body: Container(
				child: RubberBottomSheet(
					scrollController: _scrollController,
					lowerLayer: _getLowerLayer(),
					upperLayer: _getUpperLayer(),
					animationController: _controller,
				),
			),
		);
	}
	Widget _getLowerLayer() {
		return NestedScrollView(
			headerSliverBuilder: _sliverBuilder,
			body: _getDrawerItemWidget(_selectedDrawerIndex)
		);
	}

	Widget _getUpperLayer() {
		switch(_sheetType) {
			case 1:
				return _getBottomSheet();
			case 2:
				return _getFullPageSheet();
			default:
				return Scaffold();
		}
	}

	Widget _getBottomSheet() {
		return Container(
			color: Color.fromARGB(250, 37, 32, 34),
			child: Column(
				children: <Widget>[
					SizedBox(
						height: 3,
						child: LinearProgressIndicator(
							backgroundColor: Colors.transparent,
							value: _value.toString()=="NaN"? 0: _value,
							valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[200]),
						),
					),
					Expanded(
						child: ListTile(
							leading: ClipRRect(
								borderRadius: BorderRadius.circular(15.0),
								child: Icon(Icons.image),
							),
							title: Text(_music.name, style: TextStyle(color: Colors.white),),
							subtitle: Text(_music.singer, style: TextStyle(color: Colors.white),),
							//onTap: _showPersBottomSheetCallBack,
							trailing: IconButton(
								icon: !_hasSong? Icon(null):_isPlaying? Icon(Icons.pause_circle_outline, size: 40, color: Color.fromARGB(200, 200, 200, 200),): Icon(Icons.play_circle_outline, size: 40, color: Color.fromARGB(200, 200, 200, 200)),
								onPressed: _isPlaying? () => PlayAudioInBackground.pause() : ()=>PlayAudioInBackground.resume(),
							),
						),
					)
				],
			),
		);
	}

	Widget _getFullPageSheet() {
		return Scaffold(
			appBar: AppBar(
				title: Text('Full Page'),
			),
			body: Container(
				child: Center(
					child: Text('hi'),
				),
			),
		);
	}

	List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
		return <Widget>[
			SliverAppBar(
				elevation: 2,
				forceElevated: true,
				expandedHeight: 0,
				title: Text(_title[_selectedDrawerIndex]),
			)
		];
	}
}
