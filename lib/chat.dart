import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: ChatScreen(),
    );
  }
}


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('messages').orderBy('timestamp', descending: true)
                .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  else if(!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if(snapshot.hasData) {
                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                        final message = messages[index];
                        final timestamp = message['timestamp'];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black,
                                            width: 1
                                        )
                                    ),
                                    child: Padding(padding: EdgeInsets.all(5),
                          child:  Column (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(message['text'], style: TextStyle(fontWeight: FontWeight.bold),),

                                SizedBox(height: 1),
                                Text(
                                    timestamp!=null ? DateFormat('h:mm a').format(timestamp.toDate()) : '...',
                                  style: TextStyle(
                                    fontSize: 10
                                  ),
                                ),

                              ]
                          ),
                          )

                                ),
                                SizedBox(height: 20)
                              ],
                            ),
                            SizedBox(width: 10)
                          ]
                        );
                        }
                    );
                  }
                  else {
                    return Center( child: Text('Something is wrong'),);
                  }
                }),
        ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Type a message'
                  ),
                )),
                IconButton(
                    onPressed: ()=> _sendMessage(),
                    icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }

  void _sendMessage() async {
    final text = _textEditingController.text.trim();
    if(text.isNotEmpty) {
      try{
        await FirebaseFirestore.instance.collection('messages').add({
          'text' : text,
          'timestamp' : FieldValue.serverTimestamp()
        });
        _textEditingController.clear();
      } catch(e) {
        print('Error sending message: $e');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to send message. Please try again'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context),
                      child: Text('OK'))
                ],
              );
            });
      }
    }
  }
}

