class SimpleAlbumModel {
  SimpleAlbumModel({
    required this.category,
    required this.title,
    this.isExpanded = false,
  });

  String category;
  String title;
  bool isExpanded;
}