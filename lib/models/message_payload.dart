class MessagePayload {
  final String title;
  final String body;
  final String imageUrl;

  MessagePayload({
    required this.title,
    required this.body,
    required this.imageUrl,
  });

  MessagePayload.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['body'],
        imageUrl = json['image_url'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'image_url': imageUrl,
      };
}
