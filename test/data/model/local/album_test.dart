import 'package:flutter_test/flutter_test.dart';
import 'package:galerio/data/model/local/album/album.dart';

void main() {
  group("Album", () {
    test("can instantiate", () {
      late Album album;

      album = Album();

      expect(album, isNotNull);
    });

    test("can receive parameters", () {
      late Album album;
      const albumId = "123";
      const albumName = "Test Album";
      const isAlbumInNewestOrder = true;
      const albumMediaCount = 13;

      album = Album(
        id: albumId,
        name: albumName,
        isNewestOrder: isAlbumInNewestOrder,
        count: albumMediaCount,
      );

      expect(album.id, equals(albumId));
      expect(album.name, equals(albumName));
      expect(album.isNewestOrder, equals(isAlbumInNewestOrder));
      expect(album.count, equals(albumMediaCount));
    });

    test("can instantiate from JSON", () {
      late Album album;
      const albumId = "123";
      const albumName = "Test Album";
      const isAlbumInNewestOrder = true;
      const albumMediaCount = 13;
      Map<String, dynamic> json = {
        "id": albumId,
        "name": albumName,
        "is_newest_order": isAlbumInNewestOrder,
        "count": albumMediaCount,
      };

      album = Album.fromJson(json);

      expect(album.id, equals(albumId));
      expect(album.name, equals(albumName));
      expect(album.isNewestOrder, equals(isAlbumInNewestOrder));
      expect(album.count, equals(albumMediaCount));
    });
  });
}
