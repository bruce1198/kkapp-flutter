class Music {
  int id;
  String name;
  String singer;
  String url;
  int duration;
  Music(this.id, this.name, this.singer, this.url, this.duration);
  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
        json['id'] as int,
        json['name'] as String,
        json['singer'] as String,
        json['url'] as String,
        json['duration'] as int);
  }
}