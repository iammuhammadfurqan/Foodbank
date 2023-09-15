class Message {
  final String senderId;
  final String receiverId;
  final String name;
  final String message;
  final String timeStamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.name,
    required this.message,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap(Message message) {
    return {
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'name': message.name,
      'message': message.message,
      'timeStamp': message.timeStamp,
    };
  }
}
