import 'package:accurate_laboratory/login/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../login/presentation/widgets/common_textfield.dart';
import '../../../login/presentation/widgets/login_button.dart';
import '../../../shared/data/data_source/get_staff_data.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _forgotPasswordKey = GlobalKey<FormState>();
  String email = '';
  TextEditingController emailController = TextEditingController();

  dynamic staffData = [];
  getStaffData() async {
    var staff = Staff();
    staffData = await staff.getStaffDetail();
    setState(() {
      staffData;
    });
    print(staffData);
  }

  @override
  void initState() {
    super.initState();
    getStaffData();
  }

  // bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Form(
            key: _forgotPasswordKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 25, right: 25),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    child: CommonTextField(
                      labelName: 'Email',
                      obscureText: false,
                      onChange: (emailValue) {
                        email = emailValue;
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                        width: 200,
                        height: 50,
                        child: LoginButton(
                          buttonColor: primaryColor,
                          onPress: () async {
                            List<dynamic> staffEmail = staffData
                                .where((element) => element['email'] == email).toList();
                            print(staffEmail);
                            if (_forgotPasswordKey.currentState!.validate()) {
                              if (staffEmail.isNotEmpty) {
                                final FirebaseAuth _firebaseAuth =
                                    FirebaseAuth.instance;
                                await _firebaseAuth.sendPasswordResetEmail(
                                  email: email,
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please Enter Validate Email.'),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please Enter Email.'),
                                ),
                              );
                            }
                          },
                          buttonName: 'Send',
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
