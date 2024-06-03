import 'package:flutter/material.dart';
import 'package:student_mng/DBoperationsRepo/authrepository.dart';
import 'package:student_mng/util/constants.dart';
import 'package:student_mng/util/textformfields.dart';
import 'package:student_mng/views/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLogin = false;
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onEmailVerified() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/login.jpg'),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormFields.formField("Enter the Mail", (value) {
                          if (!(value.toString().contains('@'))) {
                            return "Invalid Email";
                          } else {
                            return null;
                          }
                        }, email, "Mail"),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormFields.formField("Enter the Password", (value) {
                          if ((value.toString().length < 8)) {
                            return "password should be of >= 8 char";
                          } else {
                            return null;
                          }
                        }, pass, "Password"),
                        const SizedBox(
                          height: 20,
                        ),
                        (isLoading)
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (isLogin) {
                                      bool res = await AuthRepository().login(
                                          email.text.trim(),
                                          pass.text.trim(),
                                          context);
                                      if (res) {
                                        debugPrint("hi I am here............");
                                        onEmailVerified();
                                      } else {
                                        debugPrint("Invalid Credentails");
                                      }
                                    } else {
                                      await AuthRepository().sendEmail(
                                          email.text.trim(),
                                          pass.text.trim(),
                                          onEmailVerified,
                                          context);
                                    }
                                    debugPrint("ok");
                                    email.clear();
                                    pass.clear();
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainColor,
                                ),
                                child: (isLogin)
                                    ? const Text("Sign In")
                                    : const Text("Sign Up")),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () {
                              isLogin = !isLogin;
                              setState(() {});
                            },
                            child: (isLogin)
                                ? const Text(
                                    "Don't have an account? SignUp",
                                  )
                                : const Text(
                                    "Already have an account? Sign In")),
                      ],
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
