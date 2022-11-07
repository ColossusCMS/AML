class Album {
  Album({
    required this.id,
    required this.released,
    required this.title,
    required this.artist,
    required this.artistGroup,
    required this.albumArt,
    this.isExpanded = false,
  });

  int id;
  String released;
  String title;
  String artist;
  String artistGroup;
  String albumArt;
  bool isExpanded;
}