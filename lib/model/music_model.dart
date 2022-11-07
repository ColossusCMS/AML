class Music {
  Music({
    // required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.path,
    required this.ext,
    required this.albumArt,
    this.isExpanded = false,
  });

  // int id;
  String title;
  String artist;
  String album;
  String path;
  String ext;
  String albumArt;
  bool isExpanded;
}