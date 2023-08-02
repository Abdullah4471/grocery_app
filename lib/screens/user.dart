

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:grocery_app/screens/auth/forget_password.dart';
import 'package:grocery_app/screens/auth/loading_manager.dart';
import 'package:grocery_app/screens/order/order_screen.dart';
import 'package:grocery_app/screens/viewed_recently/viewed_recently.dart';
import 'package:grocery_app/screens/whishlist/wish_list_screen.dart';
import 'package:grocery_app/services/globle_method.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../provider/dark_them_provider.dart';
import 'auth/login_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressEditingController =
      TextEditingController();
  @override
  void dispose() {
    _addressEditingController.dispose();
    super.dispose();
  }
  final User? user =authInstance.currentUser;
  bool _isLoading=false;
  String? _name;
  String? _email;
  String? address;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressEditingController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethod.errorDialog(subTitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final themState = Provider.of<DarkThemeProvider>(context);
    final Color color = themState.getDarkTheme ? Colors.white : Colors.black;
    bool _isDark = themState.getDarkTheme;

    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RichText(
                      text: TextSpan(
                          text: "Hi,  ",
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w600,
                              fontSize: 27,
                              color: Colors.cyan),
                          children: <TextSpan>[
                            TextSpan(
                                text: _name ==null?'user':_name,
                                style: GoogleFonts.rubik(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: color),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print("My Name tap is hear");
                                  }),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextWidget(
                        text: _email==null?"abc@gmail.com":_email!, color: color, textSize: 18),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // this the listTile widget i use custom it down side

                  _listTile(
                      title: "Address",
                      subtitle: address,
                      icon: IconlyLight.profile,
                      onPressed: () async {
                        await _showAddressDialog();
                      },
                      color: color),
                  _listTile(
                      title: "Order",
                      icon: IconlyLight.wallet,
                      onPressed: () {
                        GlobalMethod.navigatTo(
                            ctx: context, routeName: OrdersScreen.routeName);
                      },
                      color: color),
                  _listTile(
                      title: "Wishlist",
                      icon: IconlyLight.heart,
                      onPressed: () {
                        GlobalMethod.navigatTo(
                            ctx: context, routeName: WishlistScreen.routeName);
                      },
                      color: color),
                  _listTile(
                      title: "Viewed",
                      icon: IconlyLight.show,
                      onPressed: () {
                        GlobalMethod.navigatTo(
                            ctx: context, routeName: ViewedScreen.routeName);
                      },
                      color: color),
                  _listTile(
                      title: "Forgot Password",
                      icon: IconlyLight.lock,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ForgetPasswordScreen()));
                      },
                      color: color),
                  SwitchListTile(
                    title: _isDark
                        ? TextWidget(
                            text: "Dark mode",
                            color: color,
                            textSize: 22,
                          )
                        : TextWidget(
                            text: "Light mode",
                            color: color,
                            textSize: 22,
                          ),
                    secondary: Icon(
                      _isDark ? Icons.dark_mode_outlined : Icons.light_mode,
                      size: 30,
                    ),
                    onChanged: (bool value) {
                      themState.setDarkThem = value;
                    },
                    value: themState.getDarkTheme,
                  ),
                  _listTile(
                      title: user == null ? "Login" : "Logout",
                      icon: user == null?IconlyLight.login:IconlyLight.logout,
                      onPressed: () {
                        if (user == null) {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => LoginScreen()));
                          return;
                        }
                        GlobalMethod.warningDialog(
                            title: "Sign Out",
                            subTitle:"Do you wanna sign out",
                            fct: ()async {
                             await authInstance.signOut();
                             Navigator.of(context).push(MaterialPageRoute(builder: (_)=>LoginScreen()));
                            },
                            context: context);
                      },
                      color: color),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // This is the Alert dialog widget
  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: Text("Update"),
              content: TextFormField(
                onChanged: (value) {},
                controller: _addressEditingController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Your address",
                ),
              ),
              actions: [TextButton(onPressed: () async{
                String _uid= user!.uid;
                try{
                  await FirebaseFirestore.instance.collection('users').doc(_uid).update(
                      {
                        'shipping-address':_addressEditingController.text
                      });
                  Navigator.pop(context);
                  setState(() {
                    address=_addressEditingController.text;
                  });
                }catch (err){
                  GlobalMethod.errorDialog(subTitle: err.toString(), context: context);
                }

              }, child: Text("Update"))]);
        });
  }

  // This the ListTile widget up I used
  Widget _listTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
        isTitle: false,
      ),
      subtitle: TextWidget(
          text: subtitle == null ? "" : subtitle, color: color, textSize: 18),
      leading: Icon(icon),
      trailing: Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
