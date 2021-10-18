import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './resources/AppColors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
          child: LoginInPage(),
        ),
      ),
    );
  }
}

class LoginInPage extends StatefulWidget {
  @override
  _LoginInPageState createState() => _LoginInPageState();
}

class _LoginInPageState extends State<LoginInPage> {

  final emailController = TextEditingController();
  final passController = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.PRIMARY,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              color: AppColors.PRIMARY,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo2.png',
                      width: 90,
                      height: 90,
                    ),
                    Text(
                      "Employee Attendance System",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 25, right: 25),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  )),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 40),
                    child: const Text(
                      "Email",
                      style: TextStyle(
                          color: AppColors.TEXT_COLOR_1, fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: AppColors.TEXT_INPUT_BORDER))
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/email.png',
                          width: 18,
                          height: 18,
                        ),
                        Expanded(
                            child: TextField(
                              controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontSize: 14
                          ),
                          decoration: const InputDecoration(
                            hintText: "Your Email",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                          ),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    child: const Text(
                      "Password",
                      style: TextStyle(
                          color: AppColors.TEXT_COLOR_1, fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: AppColors.TEXT_INPUT_BORDER))
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/password.png',
                          width: 18,
                          height: 18,
                        ),
                        Expanded(
                            child: TextField(
                              controller: passController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: const TextStyle(
                                  fontSize: 14
                              ),
                              decoration: const InputDecoration(
                                  hintText: "Your Password",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 42.0,
                    margin: const EdgeInsets.only(top: 50),
                    child: RaisedButton(
                      onPressed: () => loginUser(emailController.text, passController.text),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xff4c669f), Color(0xff192f6a)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 400.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: const Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        width: 1,
                        color: Color(0xff3b5998),
                      )
                    ),
                    child: const Center(
                      child: Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff009387)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  loginUser(String email, String password) async {

    bool isValidUser = await isUserVerified(email, password);

    if(isValidUser){

      print("valid");
    }
    else{
      print("Invalid");
    }
  }

  Future<bool> isUserVerified(String email, String pass) async {

    String password;
    bool isValid = false;
    await firestoreInstance.collection("admins").where("email", isEqualTo: email)
        .get().then((value) {

      if(value.size != 0){

          password = value.docs[0].get("password").toString();
          isValid = pass == password ? true : false;

      }
    });

    return isValid;
  }
}
