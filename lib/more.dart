import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {

	final _list = ['帳號', '主題面板', '音樂辨識', 'KK 選物', '白金會員優惠', 'QR Code 掃描器', '邀請朋友', '服務中心'];

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
				title: Text('更多'),
			)
		];
	}
	ListTile _getView(BuildContext context, int index) {
		return ListTile(
			title: Text(_list[index]),
		);
	}
}