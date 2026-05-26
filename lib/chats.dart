import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minichat/welcome.dart';
import 'chatPage.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  final currentUser = FirebaseAuth.instance.currentUser;
  late final uid = currentUser!.uid;

  late Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection('USERS').
      where('uid' != uid).snapshots();


  @override
   initState()  {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHATS'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(onPressed: (){
            showDialog(context: context,
                builder: (context) {
              return AlertDialog(
                title: Text('Notice'),
                content: Text('Are you sure you want to log out?'),
                actions: [
                  ElevatedButton(onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Welcome()));
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1
                        ),
                        borderRadius: BorderRadiusGeometry.circular(5)
                      )
                    ),
                      child: Text('Yes'),
                  ),
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                  },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.black,
                                width: 1
                            ),
                            borderRadius: BorderRadiusGeometry.circular(5)
                        )
                    ),
                    child: Text('No'),
                  ),
                ],
              );
                }
            );
          },
              icon: Icon(Icons.logout),
            tooltip: 'log out',
          )
        ],
      ),
      body: StreamBuilder(
              stream: usersStream,
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
                  final users = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                      itemBuilder: (context, index) {
                      final userData = users[index].data() as Map<String, dynamic>;

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: userData['image'] != null ? NetworkImage(userData['image']) : null,
                          child: userData['image'] != null ? Icon(Icons.person, size: 20,) : null,
                        ),
                        title: Text(userData['firstName']?? 'No Name'),
                        subtitle: Text(userData['email']?? ''),

                        onTap: () {

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ChatPage(
                                receiverId: userData['uid'],
                                receiverName: userData['firstName']
                              )));
                        },
                      );
                      });
                }
                return Text('Something went wrong');
              }
      ),
    );
  }
}
