import 'package:json_annotation/json_annotation.dart';

part 'album.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Album {
  @JsonKey(defaultValue: null)
  late String? id;

  @JsonKey(defaultValue: null)
  late String? name;

  @JsonKey(defaultValue: null)
  late bool? isNewestOrder;

  @JsonKey(defaultValue: null)
  late int? count;

  // Indicates whether this album contains all media.
  bool get isAllAlbum => id == "__ALL__";

  Album({
    this.id,
    this.name,
    this.isNewestOrder,
    this.count,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return _$AlbumFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AlbumToJson(this);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Album &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          count == other.count;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ count.hashCode;

  @override
  String toString() {
    return "Album {id: $id, "
        "name: $name, "
        "count: $count}";
  }
}
