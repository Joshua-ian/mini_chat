import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {

  final String receiverId;
  final String receiverName;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  final user = FirebaseAuth.instance.currentUser;
  late final senderUid = user!.uid;

  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    final String text = _messageController.text.trim();
    if(text.isNotEmpty)  {
      await FirebaseFirestore.instance.collection('MESSAGES').add({
         'message' : text,
        'senderId' : senderUid,
        'receiverId' : widget.receiverId,
         'timestamp' : FieldValue.serverTimestamp()
       });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       leading: Padding(padding: EdgeInsets.only(left: 10),
         child: CircleAvatar(
           radius: 15,
           backgroundColor: Colors.grey[200],
           child: Icon(Icons.person),
         ),
       ),
       title: Text(widget.receiverName),
       foregroundColor: Colors.white,
       backgroundColor: Colors.blue[900],
     ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/flower.jpg'),
              fit: BoxFit.cover
            )
          ),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded( child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('MESSAGES').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshots) {
                if(snapshots.hasError) {
                  return Center(child: Text('An Unexpected error occurred'));
                } else if(snapshots.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                } else if (!snapshots.hasData) {
                  return Center(child: Text('No data available'),);
                }  else if(snapshots.hasData) {
                  final messages = snapshots.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                      itemBuilder: (context, index) {
                      final message = messages[index];
                      final timestamp = message['timestamp'];

                      final isMe = message['senderId'] == senderUid;

                      final isChatMessage =
                          (message['senderId'] == senderUid && message['receiverId'] == widget.receiverId) ||
                              (message['senderId'] == widget.receiverId && message['receiverId'] == senderUid);

                      if (!isChatMessage) {
                        return SizedBox(); // skip unrelated messages
                      }

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(message['message']),
                              SizedBox(height: 3),
                              Text(
                                timestamp != null
                                    ? DateFormat('h:mm a').format(timestamp.toDate())
                                    : '',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      );

                      }
                  );

                }
               else {
                 return Text('Something went wrong');
                }
              }),),
          Row(
            children: [
              Expanded(child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Send Message',
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black,
                  suffixIcon: IconButton(onPressed: sendMessage,
                      icon: Icon(Icons.send,
                        color: Colors.blueAccent,
                      )),
                  border: OutlineInputBorder()
                ),
              ))
            ],
          )
        ],
      ),
      )
      )
    );
  }
}
