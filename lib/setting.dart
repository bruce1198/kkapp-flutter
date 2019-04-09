import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {

	final _list = ['版本資訊', '關於', '離開'];
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: NestedScrollView(
				headerSliverBuilder: _sliverBuilder,
				body: Container(
					child: Center(
						child: ListView.builder(
							itemCount: _list.length,
							itemBuilder: _getView,
						)
					),
				)
			)
		);
	}
	List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
		return <Widget>[
			SliverAppBar(
				elevation: 2,
				forceElevated: true,
				expandedHeight: 0,
				flexibleSpace: FlexibleSpaceBar(
					centerTitle: true,
				),
				title: Text('設定'),
			)
		];
	}
	ListTile _getView(BuildContext context, int index) {
		return ListTile(
			title: Text(_list[index]),
		);
	}
}