import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minichat/chats.dart';
import 'package:minichat/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    if(_formKey.currentState!.validate()) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Chats()));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/winds.jpg'),
                        fit: BoxFit.cover
                    )
                ),
                child: Center(
                  child: SizedBox(
                      height: 450,
                      width: 300,
                        child: InkWell(
                          onTap: () {},
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10),
                                side: BorderSide(
                                    color: Colors.black45
                                )
                            ),
                            child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 30,),
                                      Text('LOGIN', style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          controller: _emailController,
                                          validator: (value) {
                                            if(value == null || value.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            else if (!value.contains('@')) {
                                              return 'Enter a valid email';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue
                                                  )
                                              ),
                                              labelText: 'Email',
                                              labelStyle: TextStyle(
                                                  color: Colors.black
                                              ),
                                              hintText: 'Enter your Email'
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                          controller: _passwordController,
                                          validator: (value) {
                                            if(value == null || value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            else if(value.length < 6) {
                                              return 'Password is too short';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue
                                                  )
                                              ),
                                              labelText: 'Password',
                                              labelStyle: TextStyle(
                                                  color: Colors.black
                                              ),
                                              hintText: 'Enter your Password'
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ElevatedButton(onPressed: () {
                                        loginUser();
                                      },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                          child: Text('SUBMIT')),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text('Not Registered?'),
                                          SizedBox(width: 60),
                                          ElevatedButton(onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => Register()));
                                          },
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.blue,
                                                  backgroundColor: Colors.white,
                                                  side: BorderSide(
                                                      color: Colors.blue,
                                                      width: 1
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20)
                                                  )
                                              ),
                                              child: Text('Register')),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      )),
                )
            )
    );
  }
}
