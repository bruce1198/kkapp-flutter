import 'package:flutter/material.dart';

class MyMusic extends StatelessWidget {

	final _lists = ['全部歌曲', '可離線播放歌曲', '播放紀錄', '我的收藏', '收藏歌曲', '收藏專輯', '收藏歌單', '我的歌單'];
	final _icons = [Icons.library_music, Icons.file_download, Icons.restore, null, Icons.favorite_border, Icons.favorite_border, Icons.favorite_border, null];
	@override
	Widget build(BuildContext context) {
		return Container(
			child: Center(
				child: 
					ListView.builder(
						itemCount: 8,
						padding: EdgeInsets.only(top: 0.0),
						itemBuilder: _getGeneral,
					),
			) 
		);
	}
	Widget _getGeneral(BuildContext context, int index) {
	
		if(index == 3 || index == 7) {
			return ListTile(
				title: Text(
					_lists[index],
					style: TextStyle(
						fontWeight: FontWeight.bold
					),
				),
			);
		}
		return ListTile(
			leading: Icon(_icons[index]),
			title: Text(_lists[index]), 
			onTap: () {

			},
		);
	}
}