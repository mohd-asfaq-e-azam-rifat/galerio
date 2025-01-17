import 'package:flutter/foundation.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/data/model/local/medium/medium.dart';

class MediaPage {
  final Album album;

  final int start;

  final List<Medium> items;

  final bool? lightWeight;

  int get end => start + items.length;

  bool get isLast => end >= (album.count ?? 0);

  MediaPage(this.album, this.start, this.items, this.lightWeight);

  MediaPage.fromJson(this.album, dynamic json, {this.lightWeight})
      : start = json['start'] ?? 0,
        items = json['items'].map<Medium>((x) => Medium.fromJson(x)).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaPage &&
          runtimeType == other.runtimeType &&
          album == other.album &&
          start == other.start &&
          listEquals(items, other.items);

  @override
  int get hashCode => album.hashCode ^ start.hashCode ^ items.hashCode;

  @override
  String toString() {
    return 'MediaPage {album: $album, '
        'start: $start, '
        'items: $items}';
  }
}
