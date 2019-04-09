import 'package:flutter/material.dart';
import 'discover/new.dart';
import 'discover/select.dart';
import 'discover/top.dart';
import 'discover/type.dart';

class DiscoverPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return DiscoverPageState();
	}
}

class DiscoverPageState extends State<DiscoverPage> {

	final List<Tab> lists = <Tab>[Tab(text: '精選'), Tab(text: '排行榜'), Tab(text: '新發行'), Tab(text: '曲風情境')];
	final List<Widget> views = [MusicSelect(), MusicTop(), MusicNew(), MusicType()];
	@override
  	Widget build(BuildContext context) {
    	return DefaultTabController(
			length: lists.length,
			child: Scaffold(
				appBar: TabBar(
					isScrollable: true,
					tabs: lists,
					indicatorWeight: 4,
					indicatorColor: Colors.blue,
					labelColor: Colors.blue,
					unselectedLabelColor: Colors.black,
				),
				body: TabBarView(
					children: views,
				),
			) 
		);
  	}
}