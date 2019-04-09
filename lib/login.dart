import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'main.dart';

class LoginPage extends StatelessWidget{

	final images = ['assets/pic1.jpg', 'assets/pic2.jpg', 'assets/pic3.jpg', 
	'assets/pic4.jpg', 'assets/pic5.jpg'];

	@override
  	Widget build(BuildContext context) {
    return Scaffold(
		body: Swiper(
			itemBuilder: (BuildContext context,int index){
				return new Image.asset(images[index],fit: BoxFit.cover,);
			},
			itemCount: images.length,
			pagination: null,
			control: null
		),
		floatingActionButton: Column(
			mainAxisSize: MainAxisSize.min,
			children: <Widget>[
				Container(
					padding: EdgeInsets.only(bottom: 10),
					child: ClipRRect(
					borderRadius: BorderRadius.circular(30),
					child: ButtonTheme(
						minWidth: 300,
						height: 50,
						child: RaisedButton(
							color: Colors.blue[500],
							padding: EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 4),
							onPressed: () {
								Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DoRegistPage()));								
							},
							child: Text(
								'加入KKAPP',
								style: TextStyle(
									fontSize: 16,
									color: Colors.white
								),
							),
						)
					)
				)),
				ClipRRect(
					borderRadius: BorderRadius.circular(30),
					child: ButtonTheme(
						minWidth: 300,
						height: 50,
						child: OutlineButton(
							borderSide: BorderSide(
								color: Colors.white,
								width: 3
							),
							highlightedBorderColor: Colors.white,
							shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
							color: Colors.blue[500],
							padding: EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 4),
							onPressed: () {
								Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DoLoginPage()));
							},
							child: Text(
								'登入',
								style: TextStyle(
									fontSize: 16,
									color: Colors.white
								),
							),
						)
					)
				),
			],
		),
		floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
	);
  }
}
class DoLoginPage extends StatefulWidget {
	@override
  	State<StatefulWidget> createState() => DoLoginPageState();
}

class DoLoginPageState extends State<DoLoginPage> {

	String _email;
	String _password;
	bool _emailFocus =false;
	bool _passwordFocus =false;
	final _accountController = TextEditingController();
	final _accoutFocusNode = FocusNode();
	final _passController = TextEditingController();
	final _passFocusNode = FocusNode();

	@override
	void initState() {
		super.initState();
		_accountController.addListener(() {
			_email = _accountController.text;
			//print(_email);
		});
		_accoutFocusNode.addListener(() {
			setState(()=> _emailFocus = _accoutFocusNode.hasFocus);
		});
		_passController.addListener(() {
			_password = _passController.text;
		});
		_passFocusNode.addListener(() {
			setState(() =>_passwordFocus = _passFocusNode.hasFocus);
		});
	}

	@override
  	Widget build(BuildContext context) {
	_saveLogin() async {
		final prefs = await SharedPreferences.getInstance();
		// set value
		prefs.setBool('isLogin', true);
		print(_email);
		prefs.setString('email', _email);
	}
    return Scaffold(
		appBar: AppBar(
			title: Text('登入KKAPP'),
		),
		body: Container(
			child: Column(
				children: <Widget>[
					Container(
						color: Colors.white,
						alignment: Alignment.topCenter,
						padding: EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 10),
						child: TextField(
							focusNode: _accoutFocusNode,
							keyboardType: TextInputType.emailAddress,
							cursorWidth: 0.5,
							cursorColor: Colors.black,
							decoration: InputDecoration(
								prefixIcon: Icon(Icons.email),
								labelStyle: TextStyle(
									color: _emailFocus? Colors.blue[300]: Colors.grey 
								),
								focusedBorder: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								labelText: '電子信箱/手機號碼'
							),
							controller: _accountController,
							maxLines: 1,
						),
					),
					Container(
						color: Colors.white,
						alignment: Alignment.topCenter,
						padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
						child: TextField(
							focusNode: _passFocusNode,
							cursorWidth: 0.5,
							cursorColor: Colors.black,
							decoration: InputDecoration(
								//contentPadding: EdgeInsets.only(top: 25, bottom: 15),
								prefixIcon: Icon(Icons.vpn_key),
								labelStyle: TextStyle(
									color: _passwordFocus? Colors.blue[400]: Colors.grey 
								),
								focusedBorder: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								
								labelText: '密碼(4-14個英文或數字)'
							),
							controller: _passController,
							maxLines: 1,
							obscureText: true,
						),
					),
					ClipRRect(
					borderRadius: BorderRadius.circular(30),
					child: ButtonTheme(
						minWidth: 300,
						height: 50,
						child: RaisedButton(
							color: Colors.blue[500],
							padding: EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 4),
							onPressed: () {
								_doLogin(_email, _password).then((response) {
									if(response=='success') {
										Navigator.pushAndRemoveUntil(
											context,
											MaterialPageRoute(builder: (BuildContext context) => MainPage()),
											(Route<dynamic> route) => false
										);
										_saveLogin();
									}
									else {
										//fail
									}
								});
							},
							child: Text(
								'登入KKAPP',
								style: TextStyle(
									fontSize: 16,
									color: Colors.white
								),
							),
						)
					)
				) 
				],
			),
		),
	);
  }
}
Future<String> _doLogin(String email, String password) async {
	//print(email);
	var url = "http://140.114.207.97/kkapp/users/apis/info/do_login.php";
	final response = await http.post(url,
		body: {
			'email' : email,
			'password' : password
		}
	);
	print(response.body);
	return compute(_parseData, response.body);
}
String _parseData(String response) {
	final parsed = response;
	return parsed;
}
class DoRegistPage extends StatefulWidget {
	@override
  	State<StatefulWidget> createState() => DoRegistPageState();
}

class DoRegistPageState extends State<DoRegistPage> {
	String _email;
	String _password;
	String _name;
	bool _emailFocus =false;
	bool _passwordFocus =false;
	bool _nameFocus =false;
	final _accountController = TextEditingController();
	final _accoutFocusNode = FocusNode();
	final _passController = TextEditingController();
	final _passFocusNode = FocusNode();
	final _nameController = TextEditingController();
	final _nameFocusNode = FocusNode();

	@override
	void initState() {
		super.initState();
		_accountController.addListener(() {
			_email = _accountController.text;
		});
		_accoutFocusNode.addListener(() {
			setState(()=> _emailFocus = _accoutFocusNode.hasFocus);
		});
		_passController.addListener(() {
			_password = _passController.text;
		});
		_passFocusNode.addListener(() {
			setState(() =>_passwordFocus = _passFocusNode.hasFocus);
		});
		_nameController.addListener(() {
			_name = _nameController.text;
		});
		_nameFocusNode.addListener(() {
			setState(() =>_nameFocus = _nameFocusNode.hasFocus);
		});
	}

	@override
  	Widget build(BuildContext context) {
	_saveLogin() async {
		final prefs = await SharedPreferences.getInstance();
		// set value
		prefs.setBool('isLogin', true);
		prefs.setString('email', _email);
	}
    return Scaffold(
		appBar: AppBar(
			title: Text('加入KKAPP'),
		),
		body: Container(
			child: Column(
				children: <Widget>[
					Container(
						color: Colors.white,
						alignment: Alignment.topCenter,
						padding: EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 10),
						child: TextField(
							focusNode: _accoutFocusNode,
							keyboardType: TextInputType.emailAddress,
							cursorWidth: 0.5,
							cursorColor: Colors.black,
							decoration: InputDecoration(
								prefixIcon: Icon(Icons.email),
								labelStyle: TextStyle(
									color: _emailFocus? Colors.blue[300]: Colors.grey 
								),
								focusedBorder: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								labelText: '電子信箱/手機號碼'
							),
							controller: _accountController,
							maxLines: 1,
						),
					),
					Container(
						color: Colors.white,
						alignment: Alignment.topCenter,
						padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
						child: TextField(
							focusNode: _passFocusNode,
							cursorWidth: 0.5,
							cursorColor: Colors.black,
							decoration: InputDecoration(
								//contentPadding: EdgeInsets.only(top: 25, bottom: 15),
								prefixIcon: Icon(Icons.vpn_key),
								labelStyle: TextStyle(
									color: _passwordFocus? Colors.blue[400]: Colors.grey 
								),
								focusedBorder: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								
								labelText: '密碼(4-14個英文或數字)'
							),
							controller: _passController,
							maxLines: 1,
							obscureText: true,
						),
					),
					Container(
						color: Colors.white,
						alignment: Alignment.topCenter,
						padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
						child: TextField(
							focusNode: _nameFocusNode,
							cursorWidth: 0.5,
							cursorColor: Colors.black,
							decoration: InputDecoration(
								prefixIcon: Icon(Icons.supervised_user_circle),
								labelStyle: TextStyle(
									color: _nameFocus? Colors.blue[300]: Colors.grey 
								),
								focusedBorder: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(15.0),
								),
								labelText: '暱稱'
							),
							controller: _nameController,
							maxLines: 1,
						),
					),
					ClipRRect(
					borderRadius: BorderRadius.circular(30),
					child: ButtonTheme(
						minWidth: 300,
						height: 50,
						child: RaisedButton(
							color: Colors.blue[500],
							padding: EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 4),
							onPressed: () {
								_doRegist(_email, _password, _name).then((response) {
									if(response=='success') {
										Navigator.pushAndRemoveUntil(
											context,
											MaterialPageRoute(builder: (BuildContext context) => MainPage()),
											(Route<dynamic> route) => false
										);
										_saveLogin();
									}
									else {
										//fail
									}
								});
							},
							child: Text(
								'加入KKAPP',
								style: TextStyle(
									fontSize: 16,
									color: Colors.white
								),
							),
						)
					)
				) 
				],
			),
		),
	);
  }
}
Future<String> _doRegist(String email, String password, String name) async {
	var url = "http://140.114.207.97/kkapp/users/apis/info/do_register.php";
	final response = await http.post(url,
		body: {
			'email' : email,
			'password' : password,
			'name' : name
		}
	);
	print(response.body);
	return compute(_parseData, response.body);
}