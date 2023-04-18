import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:signin_signup/provider/internet_provider.dart';
import 'package:signin_signup/provider/sign_in_provider.dart';
import 'package:signin_signup/screens/forget_password_page.dart';
import 'package:signin_signup/screens/home_screen.dart';
import 'package:signin_signup/screens/registration_screen.dart';
import 'package:provider/provider.dart';
import 'package:signin_signup/utils/next__screen.dart';
import 'package:signin_signup/utils/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Rounded Loading Button
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();

  //firebase
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Your Email";
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    // Password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Password is required";
        }
        if (!regex.hasMatch(value)) {
          return "Please Enter Valid Password(Min. 6 Character)";
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    // Login Button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.lightBlue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (() {
          signIn(emailController.text, passwordController.text);
        }),
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                    child: Text(
                      "Flutter Authentication",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  emailField,
                  const SizedBox(
                    height: 25,
                  ),
                  passwordField,
                  const SizedBox(
                    height: 45,
                  ),
                  loginButton,
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        nextScreen(context, const ForgotPasswordPage());
                      },
                      child: const Text(
                        "Forget password",
                        style: TextStyle(color: Colors.lightBlue, fontSize: 12),
                      )),
                  const Divider(
                    color: Colors.black,
                    height: 2,
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Facebook SignIn Button
                        RoundedLoadingButton(
                            controller: facebookController,
                            width: MediaQuery.of(context).size.width / 2.5,
                            onPressed: () {
                              handleFacebookAuth();
                            },
                            child: Wrap(
                              children: const [
                                Icon(
                                  FontAwesomeIcons.facebook,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Login With Facebook",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14))
                              ],
                            )),
                        // Google SignIn Button
                        RoundedLoadingButton(
                            controller: googleController,
                            width: MediaQuery.of(context).size.width / 2.5,
                            onPressed: () {
                              handleGoogleSignIn();
                              // final provider = Provider.of<SignInProvider>(
                              //   context,
                              //   listen: false);
                              // provider.signInWithGoogle();
                            },
                            child: Wrap(
                              children: const [
                                Icon(
                                  FontAwesomeIcons.google,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Login With Google",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14))
                              ],
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Don't have an account ? Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: (() {
                          nextScreen(context, const RegistrationScreen());
                        }),
                        child: const Text(
                          " Register",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.lightBlue),
                        ),
                      )
                    ],
                  )
                ],
              )),
        )),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeScreen()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  // handling google sign in
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) => {
            if (sp.hasError == true)
              {
                openSnackbar(context, sp.errorCode, Colors.red),
                googleController.reset(),
              }
            else
              {
                // checking whether user exists or not
                sp.checkUserExists().then((value) async {
                  if (value == true) {
                    // user exists
                    await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              googleController.success();
                              handleAfterSignIn();
                            })));
                  } else {
                    //user does not exist
                    sp.saveDataToFirestore().then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              googleController.success();
                              handleAfterSignIn();
                            })));
                  }
                })
              }
          });
    }
  }

  //handle facebookAuth
  Future handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then((value) => {
            if (sp.hasError == true)
              {
                openSnackbar(context, sp.errorCode, Colors.red),
                facebookController.reset(),
              }
            else
              {
                // checking whether user exists or not
                sp.checkUserExists().then((value) async {
                  if (value == true) {
                    // user exists
                    await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              googleController.success();
                              handleAfterSignIn();
                            })));
                  } else {
                    //user does not exist
                    sp.saveDataToFirestore().then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              googleController.success();
                              handleAfterSignIn();
                            })));
                  }
                })
              }
          });
    }
  }

  // handle after signin
  handleAfterSignIn() {
    Future.delayed(Duration(microseconds: 1000)).then((value) {
      nextScreenReplace(context, HomeScreen());
    });
  }
}
