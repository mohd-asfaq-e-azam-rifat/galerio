import 'dart:typed_data';

Uint8List? byteArrayFromJson(List<dynamic>? json) {
  if (json == null) return null;
  return Uint8List.fromList(json.cast<int>());
}

List<int>? byteArrayToJson(Uint8List? object) {
  return object?.toList();
}
