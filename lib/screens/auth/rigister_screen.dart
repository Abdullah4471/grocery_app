import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/screens/auth/loading_manager.dart';
import 'package:grocery_app/screens/auth/login_screen.dart';
import 'package:grocery_app/services/globle_method.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import '../../consts/const.dart';
import '../../services/utils.dart';
import '../../widgets/auth_button.dart';
import '../bottom_bar_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _addressTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

     bool _isLoading=false;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading=true;
      });
      try {
    await   authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passwordTextController.text.trim());
    final User? user =authInstance.currentUser;
    final _uid =user!.uid;
    user.updateDisplayName(_fullNameController.text);
    user.reload();
    await FirebaseFirestore.instance.collection('users').doc(_uid).set(
      {
        'id': _uid,
        'name':_fullNameController.text,
        'email':_emailTextController.text.toLowerCase(),
        'shipping-address':_addressTextController.text,
        'userWish':[],
        'userCart':[],
        'createAt':Timestamp.now(),

      }
    );
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>FetchScreen()));
        print("Successfully registered");
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
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: size.height * .03,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 30,
                        )),
                    SizedBox(
                      height: size.height * .15,
                    ),
                    TextWidget(
                      text: "Welcome back",
                      color: Colors.white,
                      textSize: 30,
                      isTitle: true,
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    TextWidget(
                      text: "Sign up to continue",
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
                          //Text full Name
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            controller: _fullNameController,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty){
                                return 'This Field is missing';
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: "Full name",
                              hintStyle: GoogleFonts.rubik(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
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
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_addressFocusNode),
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
                          SizedBox(
                            height: size.height * .01,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onEditingComplete: _submitFormOnRegister,
                            focusNode: _addressFocusNode,
                            controller: _addressTextController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 10) {
                                return 'Please enter a valid address';
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: "Shipping address",
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
                        onPressed: () {},
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
                        _submitFormOnRegister();
                      },
                      buttonText: "Signup",
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Already a user?",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            children: [
                          TextSpan(
                              text: "  Sign In",
                              style: GoogleFonts.rubik(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.routeName);
                                })
                        ]))
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
