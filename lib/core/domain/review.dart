class Review {
  final String id;
  final String authorName;
  final int rating;
  final String? comment;
  final String timeAgo;

  const Review({
    required this.id,
    required this.authorName,
    required this.rating,
    this.comment,
    required this.timeAgo,
  });
}
