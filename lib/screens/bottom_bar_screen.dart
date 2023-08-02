import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/screens/category.dart';
import 'package:grocery_app/screens/user.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../provider/dark_them_provider.dart';
import 'cart/cart_screen.dart';
import 'home_screen.dart';

class BottomAppBarrScreen extends StatefulWidget {
  const BottomAppBarrScreen({Key? key}) : super(key: key);

  @override
  State<BottomAppBarrScreen> createState() => _BottomAppBarrScreenState();
}

class _BottomAppBarrScreenState extends State<BottomAppBarrScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'page': HomeScreen(),
      "title": "Home Screen",
    },
    {
      'page': CategoryScreen(),
      "title": "Category Screen",
    },
    {
      'page': CartScreen(),
      "title": "Cart Screen",
    },
    {
      'page': UserScreen(),
      "title": "User Screen",
    }
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
        unselectedItemColor: _isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: _isDark ? Colors.lightBlue.shade200 : Colors.black87,
        currentIndex: _selectedIndex,
        onTap: _selectedPage,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1
                    ? IconlyBold.category
                    : IconlyLight.category,
              ),
              label: "Categories"),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_,myCart,ch){
                  return Badge(
                    position: BadgePosition.topEnd(top: -9, end: -9),
                    badgeContent: FittedBox(
                      child: TextWidget(
                        text: myCart.getCartItems.length.toString(),
                        textSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    badgeStyle: BadgeStyle(
                        badgeColor: Colors.blue, padding: EdgeInsets.all(6)),
                    badgeAnimation: BadgeAnimation.slide(
                        toAnimate: true, animationDuration: Duration(seconds: 1)),
                    child: Icon(
                      _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy,
                    ),
                    ignorePointer: false,
                  );
                }
              ),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2,
              ),
              label: "User"),
        ],
      ),
      body: _pages[_selectedIndex]['page'],
    );
  }
}
