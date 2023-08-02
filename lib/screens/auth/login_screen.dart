

import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/screens/auth/forget_password.dart';
import 'package:grocery_app/screens/auth/loading_manager.dart';
import 'package:grocery_app/screens/auth/rigister_screen.dart';
import 'package:grocery_app/screens/bottom_bar_screen.dart';
import 'package:grocery_app/services/globle_method.dart';
import 'package:grocery_app/widgets/text_widget.dart';

import '../../consts/const.dart';
import '../../consts/firebase_const.dart';
import '../../services/utils.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/google_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName ='/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading=false;
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading=true;
    });
    if (isValid) {
      _formKey.currentState!.save();

      try {
        await   authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passwordTextController.text.trim());
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>FetchScreen()));
        print("Successfully Logged in");
      }on FirebaseException catch (error) {
        GlobalMethod.errorDialog(subTitle: "${error.message}", context: context);
        setState(() {
          _isLoading=false;
        });
      } catch (error) {
        GlobalMethod.errorDialog(subTitle: "$error", context: context);
        setState(() {
          _isLoading=false;
        });
      }finally{
        setState(() {
          _isLoading=false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    final Size size = utils.getScreenSize;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Constss.loginImagePath[index],
                  fit: BoxFit.cover,
                );
              },
              itemCount: Constss.loginImagePath.length,
              autoplay: true,
              autoplayDelay: 8000,
              duration: 800,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: size.height * .2,
                    ),
                    TextWidget(
                      text: "Welcome back",
                      color: Colors.white,
                      textSize: 30,
                      isTitle: true,
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    TextWidget(
                      text: "Sign in to continue",
                      color: Colors.white,
                      textSize: 18,
                      isTitle: false,
                    ),
                    SizedBox(
                      height: size.height * .030,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email TextFormField
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: GoogleFonts.rubik(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * .010,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            obscureText: _obscureText,
                            onEditingComplete: () {
                              _submitFormOnLogin();
                            },
                            focusNode: _passFocusNode,
                            controller: _passwordTextController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a valid password';
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: GoogleFonts.rubik(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          GlobalMethod.navigatTo(ctx: context, routeName: ForgetPasswordScreen.routeName);
                        },
                        child: Text(
                          "Forget password?",
                          style: GoogleFonts.rubik(
                              fontSize: 18,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    AuthButton(
                      fct: () {
                        _submitFormOnLogin();
                      },
                      buttonText: "Login",
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    GoogleButton(),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        TextWidget(
                          text: "OR",
                          color: color,
                          textSize: 20,
                          isTitle: true,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    AuthButton(
                      fct: () {
                        _submitFormOnLogin();

                      },
                      buttonText: "Continue as a guest",
                      primary: Colors.black,
                    ),
                    SizedBox(height: size.height*0.02,),
                    RichText(text: TextSpan(
                        text: "Don't  have an account?",style: GoogleFonts.rubik(
                      color: Colors.white,fontSize: 18,

                    ),
                        children: [
                          TextSpan(text: "  Sign up",style: GoogleFonts.rubik(fontSize: 18,color: Colors.blue,fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()..onTap= (){
                            GlobalMethod.navigatTo(ctx: context, routeName: RegisterScreen.routeName);
                              })
                        ]
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
