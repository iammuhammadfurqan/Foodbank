import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

class Chat {
  final int id;
  final String profileId;
  final String message;
  final int timestamp;

  Chat({
    required this.id,
    required this.profileId,
    required this.message,
    required this.timestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      profileId: json['profileId'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String profileId;

  const ChatScreen({super.key, required this.profileId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late Database _database;
  List<Chat> _chatMessages = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String pathToDatabase = path.join(databasePath, 'chat_database.db');

    _database = await openDatabase(
      pathToDatabase,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE IF NOT EXISTS chats ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'profileId TEXT, '
            'message TEXT, '
            'timestamp INTEGER)');
      },
    );

    await _loadChatMessages();
  }

  Future<void> _loadChatMessages() async {
    List<Map<String, dynamic>> rows = await _database.query(
      'chats',
      where: 'profileId = ?',
      whereArgs: [widget.profileId],
    );

    setState(() {
      _chatMessages = rows.map((row) => Chat.fromJson(row)).toList();
    });
  }

  Future<void> _addChatMessage(String message) async {
    try {
      await _database.insert('chats', {
        'profileId': widget.profileId,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      _textEditingController.clear();
      await _loadChatMessages();
    } catch (e) {
      print('Error adding chat message: $e');
    }
  }

  String _formatDateTime(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final DateFormat formatter = DateFormat('MMM d, y h:mm a');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _chatMessages[index].message,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDateTime(_chatMessages[index].timestamp),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            color: Colors.green[100],
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    String message = _textEditingController.text;
                    if (message.isNotEmpty) {
                      _addChatMessage(message);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
