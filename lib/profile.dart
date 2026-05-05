import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minichat/chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final user = FirebaseAuth.instance.currentUser;
  late final uid = user!.uid;

  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  XFile? _image;

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? result = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = result;
    });
    return _image;
  }

  Future<void> updateProfile() async {
    try {
      if (_image == null) {
        print("No image selected");
        return;
      }

      if (_firstController.text.isEmpty ||
          _lastController.text.isEmpty ||
          _emailController.text.isEmpty) {
        print("Fields missing");
        return;
      }



      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('USERS')
          .doc(uid)
          .set({
        'firstName': _firstController.text,
        'lastName': _lastController.text,
        'email': _emailController.text,
        'image': _image!.path,
      }, SetOptions(merge: true));

      // ✅ Navigation AFTER everything succeeds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Chats()),
      );

    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SET YOUR PROFILE'),
      ),
      body: SafeArea(
          child: Padding(padding: EdgeInsets.all(20),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null? FileImage(File(_image!.path)) : null,
                      child: _image == null? Icon(Icons.person, size: 40,) : null,
                    )
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: getImage,
                    child: Text('Set Picture')),
                SizedBox(height: 20),
                Row( mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('First Name:'),
                ],),

                TextField(
                  controller: _firstController,
                ),
                SizedBox(height: 20),
                Row( mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Last Name:'),
                  ],),
                TextField(
                  controller: _lastController,
                ),
                SizedBox(height: 20),
                Row( mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Email'),
                  ],),
                TextField(
                  controller: _emailController,
                ),
                SizedBox(height: 30),
                ElevatedButton(onPressed: updateProfile,
                    child: Text('Done'))
              ],
            ),
          )
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
