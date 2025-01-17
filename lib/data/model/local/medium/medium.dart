class Medium {
  final String id;

  final String? filename;

  final String? title;

  final int? width;

  final int? height;

  final int? size;

  final int? orientation;

  final String? mimeType;

  final DateTime? creationDate;

  final DateTime? modifiedDate;

  /// Creates a medium from platform channel protocol.
  Medium.fromJson(dynamic json)
      : id = json["id"],
        filename = json["filename"],
        title = json["title"],
        width = json["width"],
        height = json["height"],
        size = json["size"],
        orientation = json["orientation"],
        mimeType = json["mimeType"],
        creationDate = json['creationDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['creationDate'])
            : null,
        modifiedDate = json['modifiedDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['modifiedDate'])
            : null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Medium &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          filename == other.filename &&
          title == other.title &&
          width == other.width &&
          height == other.height &&
          orientation == other.orientation &&
          mimeType == other.mimeType &&
          creationDate == other.creationDate &&
          modifiedDate == other.modifiedDate;

  @override
  int get hashCode =>
      id.hashCode ^
      filename.hashCode ^
      title.hashCode ^
      width.hashCode ^
      height.hashCode ^
      orientation.hashCode ^
      mimeType.hashCode ^
      creationDate.hashCode ^
      modifiedDate.hashCode;

  @override
  String toString() {
    return 'Medium {id: $id, '
        'filename: $filename, '
        'title: $title, '
        'width: $width, '
        'height: $height, '
        'orientation: $orientation, '
        'mimeType: $mimeType, '
        'creationDate: $creationDate, '
        'modifiedDate: $modifiedDate}';
  }
}
