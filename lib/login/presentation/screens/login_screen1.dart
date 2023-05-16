// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../../../home/presentation/screens/home_screen1.dart';

// class LoginScreen1 extends StatelessWidget {
//   final _phoneController = TextEditingController();
//   final _passController = TextEditingController();
//   final _codeController = TextEditingController();
//   dynamic _credential;
//   Future registerUser(String mobile, BuildContext context) async {
//     FirebaseAuth _auth = FirebaseAuth.instance;

//     _auth.verifyPhoneNumber(
//       phoneNumber: '8320069125',
//       timeout: Duration(seconds: 60),
//       verificationCompleted: (authCredential) {
//         _auth.signInWithCredential(_credential).then((result) {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => HomeScreen1(
//                         user: result.user,
//                       )));
//         }).catchError((e) {
//           print(e);
//         });
//       },
//       verificationFailed: (authException) {
//         print(authException.message);
//       },
//       codeSent: (verificationId, forceResendingToken) {
//         //show dialog to take input from the user
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) => AlertDialog(
//                   title: Text("Enter SMS Code"),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       TextField(
//                         controller: _codeController,
//                       ),
//                     ],
//                   ),
//                   actions: <Widget>[
//                     MaterialButton(
//                       child: Text("Done"),
//                       textColor: Colors.white,
//                       color: Colors.redAccent,
//                       onPressed: () {
//                         FirebaseAuth auth = FirebaseAuth.instance;

//                         dynamic smsCode = _codeController.text.trim();

//                         _credential = PhoneAuthProvider.credential(
//                             verificationId: verificationId, smsCode: smsCode);
//                         auth.signInWithCredential(_credential).then((result) {
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       HomeScreen1(user: result.user)));
//                         }).catchError((e) {
//                           print(e);
//                         });
//                       },
//                     )
//                   ],
//                 ));
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         verificationId = verificationId;
//         print(verificationId);
//         print("Timout");
//       },
//     );
//   }

//   //Place A
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       padding: EdgeInsets.all(32),
//       child: Form(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "Login",
//               style: TextStyle(
//                   color: Colors.lightBlue,
//                   fontSize: 36,
//                   fontWeight: FontWeight.w500),
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                       borderSide: BorderSide(color: Colors.grey.shade200)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                       borderSide: BorderSide(color: Colors.grey.shade300)),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   hintText: "Phone Number"),
//               controller: _phoneController,
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                       borderSide: BorderSide(color: Colors.grey.shade200)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                       borderSide: BorderSide(color: Colors.grey.shade300)),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   hintText: "Password"),
//               controller: _passController,
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             Container(
//               width: double.infinity,
//               child: MaterialButton(
//                 child: Text("Login"),
//                 textColor: Colors.white,
//                 padding: EdgeInsets.all(16),
//                 onPressed: () {
//                   //code for sign in
//                   //Place B
//                   final mobile = _phoneController.text.trim();
//                   registerUser(mobile, context);
//                 },
//                 color: Colors.blue,
//               ),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
// }
