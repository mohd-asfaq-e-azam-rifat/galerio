import 'package:flutter_test/flutter_test.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/data/model/local/media_page/media_page.dart';
import 'package:galerio/data/model/local/medium/medium.dart';

void main() {
  group("MediaPage", () {
    test("can instantiate", () {
      late MediaPage object;
      final album = Album();
      const start = 0;
      final items = <Medium>[];
      final lightWeight = false;

      object = MediaPage(album, start, items, lightWeight);

      expect(object, isNotNull);
    });

    test("can receive parameters", () {
      late MediaPage object;
      final album = Album();
      const start = 0;
      final items = <Medium>[];
      final lightWeight = false;

      object = MediaPage(album, start, items, lightWeight);

      expect(object.album, equals(album));
      expect(object.start, equals(start));
      expect(object.items, equals(items));
      expect(object.lightWeight, equals(lightWeight));
    });
  });
}
