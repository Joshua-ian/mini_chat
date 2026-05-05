import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Chats2 extends StatefulWidget {
  const Chats2({super.key});

  @override
  State<Chats2> createState() => _Chats2State();
}

class _Chats2State extends State<Chats2> {

  Future<Map<String, dynamic>?> getUser() async {
    final doc = await FirebaseFirestore.instance.collection('USERS').doc('user1').get();
    if(doc.exists) {
      return doc.data();
    }
    return null;
  }

  Map<String, dynamic>? userData;

  @override
  Future<void> initState() async {
    // TODO: implement initState
    super.initState();
    userData = await getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHATS'),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return Center( child: Text('No data Available'),);
                }
                else if(snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                else if(snapshot.hasError) {
                  return Text('Something went wrong');
                }
                else if(snapshot.hasData) {
                  final data = userData;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: data?['image'] == null? null : FileImage(data?['image']),
                      child: data?['image'] == null? Icon(Icons.person) : null,
                    ),
                    title: data?['firstName'],
                    subtitle: data?['email'],
                  );
                }
                return Text('Something went wrong');
              }
          )
        ],
      ),
    );
  }
}
