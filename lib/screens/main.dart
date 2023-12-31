import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter_svg/svg.dart';
import 'package:umonda/custom/common_functions.dart';
import 'package:umonda/helpers/shared_value_helper.dart';
import 'package:umonda/my_theme.dart';
import 'package:umonda/presenter/bottom_appbar_index.dart';
import 'package:umonda/presenter/cart_counter.dart';
import 'package:umonda/screens/cart.dart';
import 'package:umonda/screens/category_list.dart';
import 'package:umonda/screens/home.dart';
import 'package:umonda/screens/login.dart';
import 'package:umonda/screens/profile.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

import '../placeadd/placead.dart';

class Main extends StatefulWidget {
  Main({Key key, go_back = true}) : super(key: key);

  bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;

  //int _cartCount = 0;

  BottomAppbarIndex bottomAppbarIndex = BottomAppbarIndex();

  CartCounter counter = CartCounter();

  var _children = [];

  fetchAll() {
    getCartCount();
  }

  void onTapped(int i) {
    fetchAll();
    if (!is_logged_in.$ && (i == 2)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    if (i == 3) {
      app_language_rtl.$
          ? slideLeftWidget(newPage: Profile(), context: context)
          : slideRightWidget(newPage: Profile(), context: context);
      return;
    }

    setState(() {
      _currentIndex = i;
    });
    //print("i$i");
  }

  getCartCount() async {
    Provider.of<CartCounter>(context, listen: false).getCount();
  }


  void initState() {
    _navigationController = CircularBottomNavigationController(selectedPos);

    _children = [
      Home(),
      CategoryList(
        is_base_category: true,
      ),

      is_logged_in.$ == false ?
      Login(): placead(),


      is_logged_in.$ == false ?
      Login(): Cart(
        has_bottomnav: true,
        from_navigation: true,
        counter: counter,
      ),

      Profile(),
    ];
    fetchAll();
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }


  int selectedPos = 0;

  double bottomNavBarHeight = 60;





  List<TabItem> tabItems = List.of([
    TabItem(
      Image.asset('assets/home.png'),
     //Icons.home,
      "Home",
        Colors.white,
      circleStrokeColor: Color(0xff4566be),
      //Color(0xff4566be),
      // labelStyle: TextStyle(
      //color: Colors.red,
      //fontWeight: FontWeight.bold,
      // ),
    ),
    TabItem(
      // SvgPicture.asset(
      //   'assets/circ.svg', // Replace with your SVG asset path
      //   width: 200,  // Adjust width as needed
      //   height: 200, // Adjust height as needed
      // ),
      //Image.asset('assets/appbarlogo.png'),
      Image.asset('assets/categories.png'),
      //Icons.category_outlined,
      "Categories",
        Colors.white,
      circleStrokeColor: Color(0xff4566be),
      // Color(0xff4566be),
      //circleStrokeColor: Colors.white,
    ),
    TabItem(
      Image.asset('assets/adplace.png'),
      //Icons.add_circle_outline_outlined,
      "Place Ad",
        Colors.white,
      circleStrokeColor: Color(0xff4566be),
      //Color(0xff4566be),
      // labelStyle: TextStyle(
      //fontWeight: FontWeight.normal,   pubxml f
      // ),
    ),

    TabItem(
      Image.asset('assets/cart.png'),
      //Icons.shopping_cart,
      "Cart",
      Colors.white,
      //Color(0xff4566be),
      circleStrokeColor: Color(0xff4566be),

    ),
    TabItem(
      Image.asset('assets/profile.png'),
      //Icons.person,
      "Profile",
        Colors.white,
      circleStrokeColor: Color(0xff4566be),
      //Color(0xff4566be),
    ),
  ]);


  CircularBottomNavigationController _navigationController;

  // @override
  // void initState() {
  //   super.initState();
  //   _navigationController = CircularBottomNavigationController(selectedPos);
  // }


  @override
  Widget build(BuildContext context) {
    return

      WillPopScope(
        onWillPop: () async {
          //print("_currentIndex");
          if (_currentIndex != 0) {
            fetchAll();
            setState(() {
              _currentIndex = 0;
            });
            return false;
          } else {
            CommonFunctions(context).appExitDialog();
          }
          return widget.go_back;
        },
        child:


        Scaffold(
          //extendBody: true,
          bottomNavigationBar: bottomNav(selectedPos),

          body: _children.elementAt(selectedPos),


          /* _children[_currentIndex],
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white.withOpacity(0.95),
            unselectedItemColor: Color.fromRGBO(168, 175, 179, 1),
            selectedItemColor: MyTheme.accent_color,
            selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                color: MyTheme.accent_color,
                fontSize: 12),
            unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(168, 175, 179, 1),
                fontSize: 12),
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      "assets/home.png",
                      color: _currentIndex == 0
                          ? Theme.of(context).accentColor
                          : Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label: AppLocalizations.of(context).home_ucf),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      "assets/categories.png",
                      color: _currentIndex == 1
                          ? Theme.of(context).accentColor
                          : Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label: AppLocalizations.of(context).categories_ucf),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: badges.Badge(
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.circle,
                        badgeColor: MyTheme.accent_color,
                        borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.all(5),
                      ),
                      badgeAnimation: badges.BadgeAnimation.slide(
                        toAnimate: false,
                      ),
                      child: Image.asset(
                        "assets/cart.png",
                        color: _currentIndex == 2
                            ? Theme.of(context).accentColor
                            : Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                      badgeContent: Consumer<CartCounter>(
                        builder: (context, cart, child) {
                          return Text(
                            "${cart.cartCounter}",
                            style:
                                TextStyle(fontSize: 10, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                  label: AppLocalizations.of(context).cart_ucf),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset(
                    "assets/profile.png",
                    color: _currentIndex == 3
                        ? Theme.of(context).accentColor
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 16,
                  ),
                ),
                label: AppLocalizations.of(context).profile_ucf,
              ),
            ],
          ),
        ),*/
        ),
      );
  }

  Widget bottomNav(int i) {
    return CircularBottomNavigation(
      tabItems,

      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      // use either barBackgroundColor or barBackgroundGradient to have a gradient on bar background
      barBackgroundColor: Colors.white,
      // barBackgroundGradient: LinearGradient(
      //   begin: Alignment.bottomCenter,
      //   end: Alignment.topCenter,
      //   colors: [
      //     Colors.blue,
      //     Colors.red,
      //   ],
      // ),
      backgroundBoxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        if (!is_logged_in.$ && (selectedPos == 3)) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
          return;
        }
        setState(() {
          this.selectedPos = selectedPos ?? 0;
          print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}






































































/*import 'package:hardware_lo/custom/common_functions.dart';
import 'package:hardware_lo/helpers/shared_value_helper.dart';
import 'package:hardware_lo/my_theme.dart';
import 'package:hardware_lo/presenter/bottom_appbar_index.dart';
import 'package:hardware_lo/presenter/cart_counter.dart';
import 'package:hardware_lo/screens/cart.dart';
import 'package:hardware_lo/screens/category_list.dart';
import 'package:hardware_lo/screens/home.dart';
import 'package:hardware_lo/screens/login.dart';
import 'package:hardware_lo/screens/profile.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class Main extends StatefulWidget {
  Main({Key key, go_back = true}) : super(key: key);

  bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  //int _cartCount = 0;

  BottomAppbarIndex bottomAppbarIndex = BottomAppbarIndex();

  CartCounter counter = CartCounter();

  var _children = [];

  fetchAll() {
    getCartCount();
  }

  void onTapped(int i) {
    fetchAll();
    if (!is_logged_in.$ && (i == 2)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    if (i == 3) {
      app_language_rtl.$
          ? slideLeftWidget(newPage: Profile(), context: context)
          : slideRightWidget(newPage: Profile(), context: context);
      return;
    }

    setState(() {
      _currentIndex = i;
    });
    //print("i$i");
  }

  getCartCount() async {
    Provider.of<CartCounter>(context, listen: false).getCount();
  }

  void initState() {
    _children = [
      Home(),
      CategoryList(
        is_base_category: true,
      ),
      Cart(
        has_bottomnav: true,
        from_navigation: true,
        counter: counter,
      ),
      Profile(),
    ];
    fetchAll();
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //print("_currentIndex");
        if (_currentIndex != 0) {
          fetchAll();
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          CommonFunctions(context).appExitDialog();
        }
        return widget.go_back;
      },
      child:




      Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          extendBody: true,
          body: _children[_currentIndex],
          bottomNavigationBar: SizedBox(
            height: 70,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: onTapped,
              currentIndex: _currentIndex,
              backgroundColor: Colors.white.withOpacity(0.95),
              unselectedItemColor: Color.fromRGBO(168, 175, 179, 1),
              selectedItemColor: MyTheme.accent_color,
              selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: MyTheme.accent_color,
                  fontSize: 12),
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(168, 175, 179, 1),
                  fontSize: 12),
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        "assets/home.png",
                        color: _currentIndex == 0
                            ? Theme.of(context).accentColor
                            : Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                    ),
                    label: AppLocalizations.of(context).home_ucf),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        "assets/categories.png",
                        color: _currentIndex == 1
                            ? Theme.of(context).accentColor
                            : Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                    ),
                    label: AppLocalizations.of(context).categories_ucf),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: MyTheme.accent_color,
                          borderRadius: BorderRadius.circular(10),
                          padding: EdgeInsets.all(5),
                        ),
                        badgeAnimation: badges.BadgeAnimation.slide(
                          toAnimate: false,
                        ),
                        child: Image.asset(
                          "assets/cart.png",
                          color: _currentIndex == 2
                              ? Theme.of(context).accentColor
                              : Color.fromRGBO(153, 153, 153, 1),
                          height: 16,
                        ),
                        badgeContent: Consumer<CartCounter>(
                          builder: (context, cart, child) {
                            return Text(
                              "${cart.cartCounter}",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                    label: AppLocalizations.of(context).cart_ucf),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      "assets/profile.png",
                      color: _currentIndex == 3
                          ? Theme.of(context).accentColor
                          : Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label: AppLocalizations.of(context).profile_ucf,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


*/