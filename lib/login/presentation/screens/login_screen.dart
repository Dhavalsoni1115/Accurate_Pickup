import 'package:accurate_laboratory/forgot_password/presentation/screens/forgot_password.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../shared/data/data_source/get_staff_data.dart';
import '../../../shared/services/notification_service.dart';
import '../../data/data_source/fcm_token_data.dart';
import '../../data/data_source/staff_shared_pref.dart';
import '../widgets/common_textfield.dart';
import '../widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  String email = '', password = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loginButton = false;

  dynamic selectedStaffData;
  getSelectedStaff(String staffId) async {
    var staff = Staff();
    selectedStaffData = await staff.getSelectStaffDetail(staffId);
    return selectedStaffData;
  }

  String token = '';
  getFcmToken() async {
    var fcm = NotificationService();
    token = await fcm.getDeviceToken();
    return token;
  }

  @override
  void initState() {
    super.initState();
    getFcmToken() ?? null;
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Form(
            key: _loginKey,
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
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      child: CommonTextField(
                        labelName: 'Password',
                        obscureText: showPassword == true ? false : true,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: showPassword == false
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                        onChange: (passwordValue) {
                          password = passwordValue;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //TextFormField(),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: loginButton == false
                          ? LoginButton(
                              buttonColor: primaryColor,
                              onPress: () async {
                                if (_loginKey.currentState!.validate()) {
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please Enter Email and Password.'),
                                    ),
                                  );
                                }
                                var loginUser = Staff();
                                var staffId = await loginUser.signInStaff(
                                  context: context,
                                  email: email,
                                  password: password,
                                );
                                print('id');
                                print(staffId);
                                await getSelectedStaff(staffId);
                                if (staffId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Invalid Email and Password'),
                                    ),
                                  );
                                }
                                String selectedId =
                                    await selectedStaffData['id'];
                                if (staffId == selectedStaffData['id']) {
                                  if (selectedStaffData['active'] == true) {
                                    setState(() {
                                      loginButton = true;
                                    });
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Login Sucessfull'),
                                      ),
                                    );
                                    storeFcmToken(token, staffId.toString());
                                    var sharedPref = LoginSharedPrefrance();
                                    await sharedPref
                                        .storeLoginToken(staffId.toString());

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          staffId: staffId.toString(),
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please Contact Admin'),
                                      ),
                                    );
                                  }
                                }
                                // print(selectedStaffdata.toJson());
                              },
                              buttonName: 'Login',
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: backgroundColor,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
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
