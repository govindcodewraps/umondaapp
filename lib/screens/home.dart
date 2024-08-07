import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:umonda/app_config.dart';
import 'package:umonda/custom/aiz_image.dart';
import 'package:umonda/custom/box_decorations.dart';
import 'package:umonda/helpers/shared_value_helper.dart';
import 'package:umonda/helpers/shimmer_helper.dart';
import 'package:umonda/my_theme.dart';
import 'package:umonda/presenter/home_presenter.dart';
import 'package:umonda/screens/category_products.dart';
import 'package:umonda/screens/filter.dart';
import 'package:umonda/screens/flash_deal_list.dart';
import 'package:umonda/screens/payment_method_screen/stripe_screen.dart';
import 'package:umonda/screens/todays_deal_products.dart';
import 'package:umonda/screens/top_brands.dart';
import 'package:umonda/screens/top_selling_products.dart';
import 'package:umonda/screens/wishlist.dart';
import 'package:umonda/ui_elements/mini_product_card.dart';
import 'package:umonda/ui_elements/product_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:umonda/screens/login.dart';


import '../custom/device_info.dart';
import '../custom/toast_component.dart';
import '../data_model/Notification_count_model.dart';
import '../helpers/auth_helper.dart';
import '../ui_sections/drawer.dart';
import 'Done_Screen.dart';
import 'InProfileScreen/My_Ads.dart';
import 'New_Home_Screen/All_Feature_Ads_Screen.dart';
import 'New_Home_Screen/Allnewads_Screen.dart';
import 'InProfileScreen/commisssion_history_screen.dart';
import 'New_Home_Screen/Feature_Ad_Package_Screen.dart';
import 'Notification_Screen.dart';
import 'common_webview_screen.dart';
import 'drawermenu/Aboutus.dart';
import 'drawermenu/ContactInf.dart';
import 'drawermenu/privacy_policy.dart';
import 'drawermenu/shipping_delivery.dart';
import 'drawermenu/terms_conditions.dart';
import 'main.dart';
import 'order_list.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
    this.title,
    this.show_back_button = false,
    go_back = true,
  }) : super(key: key);

  final String title;
  bool show_back_button;
  bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int badgeNo = 0;
  //HomePresenter homeData = HomePresenter();

  HomePresenter homePresenter;
  Map savecount={};
  String notificationnumber="0";






  @override
  void initState() {
    notification_count();
    Future.delayed(Duration.zero).then((value) {
      change();
    });
    // change();
    // TODO: implement initState
    super.initState();
    print("0- home.dart, is_logged_in :");
    if (is_logged_in.$ == true) {
      //fetchAll();
      print("1- home.dart, is_logged_in : ${is_logged_in}");
      print("2- home.dart, is_logged_in : ${is_logged_in.$}");
    }

  }

  change() {
    homePresenter = Provider.of<HomePresenter>(context, listen: false);
    homePresenter.onRefresh();
    homePresenter.mainScrollListener();
    homePresenter.initPiratedAnimation(this);
  }

  @override
  void dispose() {
    print("Dispose");
    // homePresenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Consumer<HomePresenter>(builder: (context, homeData, child) {
      return WillPopScope(
        onWillPop: () async {
          //CommonFunctions(context).appExitDialog();
          return widget.go_back;
        },
        child: Directionality(
          textDirection:
          app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
          child: SafeArea(
            child: Scaffold(
                key: scaffoldKey,

                appBar: AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(
                    color: Colors.black, // Change this to your desired color
                  ),
                  actions: [
                    Container(
                      color: MyTheme.white,
                      height:50,
                      padding: EdgeInsets.only(left: 16,right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/appbarlogo.png',
                            //height: 40,
                            //width: 250,
                          ),

                          SizedBox(width: 40,),
                          Row(children: [
                            InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Filter()));
                                  return;
                                },
                                child: Icon(Icons.search)),
                            SizedBox(width: 10,),
                            ///////////////////
                            // InkWell(
                            //     onTap: (){
                            //       Navigator.push(context, MaterialPageRoute(builder: (context)=>Notification_Screen()));
                            //     },
                            //     child: Icon(Icons.notifications)),


                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Notification_Screen()));
                              },
                              child: Stack(
                                children: [
                                  Icon(Icons.notifications),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: MyTheme.accent_color,
                                        borderRadius: BorderRadius.circular(50), // Set a circular border radius
                                      ),
                                      child: Text(
                                        " ${notificationnumber} ",
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),






                            SizedBox(width: 10,),
                            InkWell(
                                onTap: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Wishlist();
                                      }));
                                },
                                child: Image.asset("assets/icons/wishicon.png",height: 25,width: 25,)),




                            // SizedBox(
                            //   height: 30,
                            //   width: 30,
                            //   child: Expanded(
                            //       flex: 1,
                            //       child: buildBodyChildren()),
                            // ),
                          ],),



                        ],),
                    ),
                  ],
                ),

                drawer: MainDrawer(),
                body: Stack(
                  children: [

                    RefreshIndicator(
                      color: MyTheme.accent_color,
                      backgroundColor: Colors.white,
                      onRefresh: homeData.onRefresh,
                      displacement: 0,
                      child: CustomScrollView(
                        controller: homeData.mainScrollController,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height:150,
                              child: buildHomeFeaturedCategories(
                                  context, homeData),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              AppConfig.purchase_code == ""
                                  ? Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  9.0,
                                  16.0,
                                  9.0,
                                  0.0,
                                ),
                                child: Container(
                                  height: 140,
                                  color: Colors.black,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          left: 20,
                                          top: 0,
                                          child: AnimatedBuilder(
                                              animation: homeData
                                                  .pirated_logo_animation,
                                              builder: (context, child) {
                                                return Image.asset(
                                                  "assets/pirated_square.png",
                                                  height: homeData
                                                      .pirated_logo_animation
                                                      .value,
                                                  color: Colors.white,
                                                );
                                              })),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 24.0,
                                              left: 24,
                                              right: 24),
                                          child: Text(
                                            "This is a pirated app. Do not use this. It may have security issues.",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  : Container(),
                              InkWell(
                                  onTap: (){
                                    if(homeData.current_slider == 0){
                                      print("index Electronics");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        //return CommissionHistoryScreen();
                                        return CategoryProducts(
                                          category_id: homeData.featuredCategoryList[2].id,
                                          category_name: homeData.featuredCategoryList[2].name,
                                        );
                                      }
                                      ));
                                    }
                                    else if(homeData.current_slider == 1)
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return CategoryProducts(
                                          category_id: homeData.featuredCategoryList[0].id,
                                          category_name: homeData.featuredCategoryList[0].name,
                                        );
                                      }
                                      ));
                                      print("index fruits");
                                    }
                                    else if(homeData.current_slider == 2)
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return CategoryProducts(
                                          category_id: homeData.featuredCategoryList[1].id,
                                          category_name: homeData.featuredCategoryList[1].name,
                                        );
                                      }
                                      ));
                                      print("index fashion");
                                    }
                                  },

                                  child:
                                  buildHomeCarouselSlider(context, homeData)
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(
                              //     18.0,
                              //     0.0,
                              //     18.0,
                              //     0.0,
                              //   ),
                              //   //child: buildHomeMenuRow1(context, homeData),
                              // ),
                              //buildHomeBannerOne(context, homeData),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(
                              //     18.0,
                              //     0.0,
                              //     18.0,
                              //     18.0,
                              //   ),
                              //   child: buildHomeMenuRow2(context),    //New Ads
                              // ),
                            ]),
                          ),
                          // SliverList(
                          //   delegate: SliverChildListDelegate([
                          //     Padding(
                          //       padding: const EdgeInsets.fromLTRB(
                          //         18.0,
                          //         20.0,
                          //         18.0,
                          //         0.0,
                          //       ),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             AppLocalizations.of(context)
                          //                 .featured_categories_ucf,
                          //             style: TextStyle(
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.w700),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ]),
                          // ),

                          SliverList(
                            delegate: SliverChildListDelegate([
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  18.0,
                                  18.0,
                                  20.0,
                                  0.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        alignment: Alignment.center,
                                        // height: 60,
                                        width: DeviceInfo(context).width/1,
                                        child:
                                        SizedBox(
                                          height: 30,
                                          width:double.infinity,
                                          child: ElevatedButton(

                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(MyTheme.accent_color),

                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(

                                                        borderRadius: BorderRadius.circular(12.0),
                                                        side: BorderSide(color:MyTheme.accent_color)
                                                    )
                                                )
                                            ),

                                            onPressed: (){
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=>Feature_ad_package_Screen()));
                                            // Navigator.push(context,MaterialPageRoute(builder: (context)=>DoneScreen()));
                                            },
                                            child:Text(
                                              "Get Featured On Home Page",
                                              // AppLocalizations.of(context).update_profile_ucf,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),







                          SliverList(
                            delegate: SliverChildListDelegate([
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  18.0,
                                  18.0,
                                  20.0,
                                  0.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)
                                          .all_products_ucf,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    buildHomeAllProducts2(context, homeData),
                                    SizedBox(height: 10,),
                                    Container(
                                      padding: EdgeInsets.only(left: 18,right: 18),
                                      alignment: Alignment.center,
                                      // height: 60,
                                      width: DeviceInfo(context).width/1,
                                      child:
                                      SizedBox(
                                        height: 30,
                                        width:double.infinity,
                                        child: ElevatedButton(

                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(MyTheme.accent_color),

                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(

                                                      borderRadius: BorderRadius.circular(12.0),
                                                      side: BorderSide(color:MyTheme.accent_color)
                                                  )
                                              )
                                          ),

                                          onPressed: (){
                                            Navigator.push(context,MaterialPageRoute(builder: (context)=>Allnewads_Screen()));
                                          },
                                          child:Text(
                                            "View All",
                                            // AppLocalizations.of(context).update_profile_ucf,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),),
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 25,
                                //color: Colors.red,
                              )
                            ]),
                          ),


//featured ads
//                         if( buildHomeFeatureProductHorizontalList(
//                             homeData) == null)


                          if(homeData.featuredProductList.length > 0)
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Column(
                                  children: [
                                    Container(
                                      color: MyTheme.accent_color,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 180,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Image.asset("assets/background_1.png")
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    right: 18.0,
                                                    left: 18.0),
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .featured_products_ucf,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                              buildHomeFeatureProductHorizontalList(
                                                  homeData),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      padding: EdgeInsets.only(left: 18,right: 18),
                                      alignment: Alignment.center,
                                      // height: 60,
                                      width: DeviceInfo(context).width/1,
                                      child:
                                      SizedBox(
                                        height: 30,
                                        width:double.infinity,
                                        child: ElevatedButton(

                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(MyTheme.accent_color),

                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(

                                                      borderRadius: BorderRadius.circular(12.0),
                                                      side: BorderSide(color:MyTheme.accent_color)
                                                  )
                                              )
                                          ),

                                          onPressed: (){
                                            Navigator.push(context,MaterialPageRoute(builder: (context)=>All_feature_ads_Screen()));
                                          },
                                          child:Text(
                                            "View All",
                                            // AppLocalizations.of(context).update_profile_ucf,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),),
                                      ),

                                    ),
                                  ],
                                ),
                              ]),
                            ),


//                           SliverList(
//                             delegate: SliverChildListDelegate([
//                               Container(
//                                 color: MyTheme.accent_color,
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       height: 180,
//                                       width: double.infinity,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.end,
//                                         children: [
//                                           Image.asset("assets/background_1.png")
//                                         ],
//                                       ),
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 10.0,
//                                               right: 18.0,
//                                               left: 18.0),
//                                           child: Text(
//                                             AppLocalizations.of(context)
//                                                 .featured_products_ucf,
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.w700),
//                                           ),
//                                         ),
//                                         buildHomeFeatureProductHorizontalList(
//                                             homeData)
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ]),
//                           ),







// second banner
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // buildHomeBannerTwo(context, homeData),



                                  // Padding(
                                  //   padding: const EdgeInsets.fromLTRB(
                                  //     18.0,
                                  //     18.0,
                                  //     18.0,
                                  //     18.0,
                                  //   ),
                                  //   child: buildHomeMenuRow2(context),
                                  // ),
                                  // Container(
                                  // margin: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,right: 8),
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      decoration: BoxDecorations.buildBoxDecoration_1(),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: GestureDetector(
                                              child: Image.asset(
                                                'assets/topbrand_image.png',
                                                height: 60,
                                                width: 70,
                                                //color: MyTheme.dark_grey,
                                                color: MyTheme.dark_grey,
                                              ),

                                              // onTap: () {
                                              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              //     return TopBrand();
                                              //   }));
                                              // },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(21, 0, 0, 0),
                                            child: GestureDetector(
                                              child: Text("Top Brands",
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                TextStyle(fontSize: 20, color:Colors.black, ),
                                              ),

                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return TopBrands();
                                                }));
                                              },
                                            ),
                                          ),
                                          Container(
                                            // margin: const EdgeInsets.fromLTRB(56, 0, 0, 0),
                                            child: GestureDetector(
                                              child: Text("View All",
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                TextStyle(fontSize: 14, color: Colors.black, ),
                                              ),

                                              onTap: () {

                                                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                //   return TopBrands();
                                                // }));

                                                Navigator.push(context, MaterialPageRoute(builder: (context)
                                                {
                                                  return TopBrands(
                                                    selected_filter: "brands",
                                                  );
                                                }));


                                              },

                                            ),
                                          ),

                                        ],
                                      ),

                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,right: 8),
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                                      decoration: BoxDecorations.buildBoxDecoration_1(),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: GestureDetector(
                                              child: Image.asset(
                                                'assets/brand_image.png',
                                                height: 60,
                                                width: 70,
                                                //color: MyTheme.dark_grey,
                                                color: MyTheme.dark_grey,
                                              ),

                                              onTap: () {

                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(21, 0, 0, 0),
                                            child: GestureDetector(
                                              child: Text("All Brands",
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                TextStyle(fontSize: 20, color:Colors.black, ),
                                              ),

                                              onTap: () {

                                              },
                                            ),
                                          ),
                                          Container(
                                            //margin: const EdgeInsets.fromLTRB(61, 0, 0, 0),
                                            child: GestureDetector(
                                              child: Text("View All",
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                TextStyle(fontSize: 14, color:Colors.black, ),
                                              ),

                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return Filter(
                                                    selected_filter: "brands",
                                                  );
                                                }));
                                              },
                                            ),
                                          ),

                                        ],
                                      ),

                                    ),
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            ],
                            ),
                          ),

                        ],
                      ),
                    ),


                    Align(
                        alignment: Alignment.center,
                        child: buildProductLoadingContainer(homeData))
                  ],
                )),
          ),
        ),
      );
    });
  }


  MainDrawer(){
    return Drawer(

      child: Container(
        //color: Colors.blue,
        child: ListView(

          padding: EdgeInsets.zero,
          children: <Widget>[



            UserAccountsDrawerHeader(

              currentAccountPicture:
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: MyTheme.white, width: 1),
                    shape: BoxShape.rectangle,
                  ),
                  child: is_logged_in.$
                      ? ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/profile_placeholder.png',
                        image: "${avatar_original.$}",
                        fit: BoxFit.fill,
                      ))
                      : Image.asset('assets/profile_placeholder.png',
                    height: 260,
                    width: 260,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),

              accountName: Text('${user_name.$}'),
              accountEmail: Text('${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}'),
              decoration: BoxDecoration(color: Colors.amber),
            ),
            ListTile(
              leading: Icon(
                Icons.home,color: Colors.grey,
              ),
              title:  Text('Home',style: TextStyle(color: MyTheme.accent_color),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              //leading: Image.asset("assets/heart.png",height: 20,width: 20,color: Colors.grey,),
              leading: Icon(Icons.monetization_on_outlined),
              title:  Text('My Sales',style: TextStyle(color: MyTheme.accent_color),),
              onTap: () {


                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>My_adsScreen()));
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>StripeScreen()));
              },
            ),
            ListTile(
              leading: Image.asset("assets/heart.png",height: 20,width: 20,color: Colors.grey,),
              title:  Text('My Wishlist',style: TextStyle(color: MyTheme.accent_color),),
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Wishlist()));
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>StripeScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.history,color: Colors.grey,
              ),
              title:  Text('My Purchases',style: TextStyle(color: MyTheme.accent_color),),
              onTap: () {
                // Navigator.pop(context);
                //OrderList
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderList()));
              },
            ),
            ListTile(
              leading:Image.asset("assets/truck.png",height: 20,width: 20,color: Colors.grey,),
              title:

              RichText(
                maxLines: 2,
                text:
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommonWebviewScreen(
                                    page_name:
                                    "Shipping & Delivery",
                                    url:
                                    //"https://umonm.com/",
                                    "${AppConfig.RAW_BASE_URL}/mobile-page/shipping",
                                  )));
                    },
                  style:
                  TextStyle(color: MyTheme.accent_color),
                  text: " Shipping & Delivery",
                ),
              ),

              //const Text('Shipping & Delivery'),
              onTap: () {
                // Navigator.pop(context);
                //  Navigator.push(context, MaterialPageRoute(builder: (context) {
                //    return ShippingDelivery();
                //  }));
              },
            ),
            ListTile(
              leading:
              Image.asset("assets/termm.png",height: 20,width: 20,color: Colors.grey,),
              title:
              RichText(
                maxLines: 2,
                text:
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommonWebviewScreen(
                                    page_name:
                                    "Terms & Conditions",
                                    url:
                                    //"https://umonm.com/",
                                    "${AppConfig.RAW_BASE_URL}/mobile-page/terms",
                                  )));
                    },
                  style:
                  TextStyle(color: MyTheme.accent_color),
                  text: " Terms & Conditions",
                ),
              ),
              //const Text('Terms & Condition'),
              // onTap: () {
              //   Navigator.pop(context);
              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     return TermsConditions();
              //   }));
              // },
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,color: Colors.grey,
              ),
              title:
              RichText(
                maxLines: 2,
                text:
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommonWebviewScreen(
                                    page_name:
                                    "Privacy Policy",
                                    url:
                                    //"https://umonm.com/",
                                    "${AppConfig.RAW_BASE_URL}/mobile-page/privacy-policy",
                                  )));
                    },
                  style:
                  TextStyle(color: MyTheme.accent_color),
                  text: " Privacy Policy",
                ),
              ),

              //const Text('Privacy Policy'),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return PrivacyPolicy();
                // }));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,color: Colors.grey,
              ),
              title:
              RichText(
                maxLines: 2,
                text:
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommonWebviewScreen(
                                    page_name:
                                    "About Us",
                                    url:
                                    //"https://umonm.com/",
                                    "${AppConfig.RAW_BASE_URL}/mobile-page/about-us",
                                    //"https://webcluestechnology.com/demo/erp/umonda/api/v2/stripe?payment_type=cart_payment&order_id=444&amount=1200&user_id=198",

                                    //"https://umonda.com/about-us",
                                  )));
                    },
                  style:
                  TextStyle(color: MyTheme.accent_color),
                  text: " About Us",
                ),
              ),
              //const Text('About Us'),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return Aboutus();
                // }));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.phone_android,color: Colors.grey,
              ),
              title:
              RichText(
                maxLines: 2,
                text:
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommonWebviewScreen(
                                    page_name:
                                    "Contact-us",
                                    url:
                                    //"https://umonm.com/",
                                    "${AppConfig.RAW_BASE_URL}/contact-us",
                                  )));
                    },
                  style:
                  TextStyle(color: MyTheme.accent_color),
                  text: " Contact-us",
                ),
              ),

              // const Text('Contact Information'),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return ContactInf();
                // }));
              },
            ),

            is_logged_in.$ == false ?
            ListTile(
              leading: Icon(
                Icons.login,color: Colors.green,
              ),
              title:  Text('LogIn',style: TextStyle(color:Colors.green),),
              onTap: () {

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Login();
                }));
              },
            )
                :

            ListTile(
              leading: Icon(
                Icons.logout,color: Colors.red,
              ),
              title:  Text('LogOut',style: TextStyle(color:Colors.red),),
              onTap: () {

                Navigator.pop(context);
                      AuthHelper().clearUserData();
                      Provider.of<HomePresenter>(context,listen: false).dispose();

                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                        return Main();
                      }), (route) => false);
              },
            )



            //
            // is_logged_in.$ == false ?
            //
            // ListTile(
            //   leading: Icon(
            //     Icons.logout,color: Colors.red,
            //   ),
            //   title:
            //
            //   is_logged_in.$ == false ?
            //   ///Login()
            //   InkWell(
            //       onTap: ()
            //       {
            //         Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
            //       },
            //       child: Text("Login"))
            //       :
            //   Text('Log Out',style: TextStyle(color:Colors.red),),
            //   onTap: () {
            //     Navigator.pop(context);
            //     AuthHelper().clearUserData();
            //     Provider.of<HomePresenter>(context,listen: false).dispose();
            //
            //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
            //       return Main();
            //     }), (route) => false);
            //   },
            // ):              InkWell(
            //     onTap: () {
            //       Navigator.pop(context);
            //       AuthHelper().clearUserData();
            //       Provider.of<HomePresenter>(context,listen: false).dispose();
            //
            //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
            //         return Main();
            //       }), (route) => false);
            //     },
            //     child: Text('Log Out',style: TextStyle(color:Colors.red),)),


          ],

        ),
      ),

    );

  }


  Widget buildHomeAllProducts(context, HomePresenter homeData) {
    if (homeData.isAllProductInitial && homeData.allProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.allProductScrollController));
    } else if (homeData.allProductList.length > 0) {
      //snapshot.hasData

      return GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: homeData.allProductList.length,
        controller: homeData.allProductScrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.618),
        padding: EdgeInsets.all(16.0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
            id: homeData.allProductList[index].id,
            image: homeData.allProductList[index].thumbnail_image,
            name: homeData.allProductList[index].name,
            main_price: homeData.allProductList[index].main_price,
            stroked_price: homeData.allProductList[index].stroked_price,
            has_discount: homeData.allProductList[index].has_discount,
            discount: homeData.allProductList[index].discount,
          );
        },
      );
    } else if (homeData.totalAllProductData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context).no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomeAllProducts2(context, HomePresenter homeData) {
    if (homeData.isAllProductInitial && homeData.allProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.allProductScrollController));
    } else if (homeData.allProductList.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          itemCount: homeData.allProductList.length =4,
         // itemCount: homeData.allProductList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.0, bottom: 1, left: 18, right: 18),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  //border: Border.all(color: MyTheme.accent_color),
                  boxShadow: [BoxShadow(blurRadius: 10,color: Colors.grey,offset: Offset(1,3))]
              ),
              //height: 270,
              child: ProductCard(
                id: homeData.allProductList[index].id,
                image: homeData.allProductList[index].thumbnail_image,
                name: homeData.allProductList[index].name,
                main_price: homeData.allProductList[index].main_price,
                stroked_price: homeData.allProductList[index].stroked_price,
                has_discount: homeData.allProductList[index].has_discount,
                discount: homeData.allProductList[index].discount,
                is_wholesale:
                homeData.allProductList[index].isWholesale,
              ),
            );
          });
    } else if (homeData.totalAllProductData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context).no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomeFeaturedCategories(context, HomePresenter homeData) {
    if (homeData.isCategoryInitial &&
        homeData.featuredCategoryList.length == 0) {
      return ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 14.0,
          item_count: 10,
          mainAxisExtent: 170.0,
          controller: homeData.featuredCategoryScrollController);
    } else if (homeData.featuredCategoryList.length > 0) {
      //snapshot.hasData
      return GridView.builder(
          padding:
          const EdgeInsets.only(left: 18, right: 18, top: 15, bottom:0),
          scrollDirection: Axis.horizontal,
          controller: homeData.featuredCategoryScrollController,
          itemCount: homeData.featuredCategoryList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 80.0),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CategoryProducts(
                    category_id: homeData.featuredCategoryList[index].id,
                    category_name: homeData.featuredCategoryList[index].name,
                  );
                }));
              },
              child: Container(
                //decoration: BoxDecorations.buildBoxDecoration_1(),

                child: Column(

                  children: <Widget>[
                    Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(300.0),
                            // borderRadius: BorderRadius.horizontal(
                            //     left: Radius.circular(16), right: Radius.circular(16)),
                            child: FadeInImage.assetNetwork(
                              width: 80,
                              height: 80,
                              placeholder: 'assets/placeholder.png',
                              image:
                              homeData.featuredCategoryList[index].banner,
                              fit: BoxFit.cover,
                            ))),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          homeData.featuredCategoryList[index].name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(fontSize: 12, color:Colors.black,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else if (!homeData.isCategoryInitial &&
        homeData.featuredCategoryList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).no_category_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }



  // Widget buildHomeFeaturedCategories(context, HomePresenter homeData) {
  //   if (homeData.isCategoryInitial &&
  //       homeData.featuredCategoryList.length == 0) {
  //     return ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
  //         crossAxisSpacing: 14.0,
  //         mainAxisSpacing: 14.0,
  //         item_count: 10,
  //         mainAxisExtent: 170.0,
  //         controller: homeData.featuredCategoryScrollController);
  //   } else if (homeData.featuredCategoryList.length > 0) {
  //     //snapshot.hasData
  //     return GridView.builder(
  //         padding:
  //             const EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 20),
  //         scrollDirection: Axis.horizontal,
  //         controller: homeData.featuredCategoryScrollController,
  //         itemCount: homeData.featuredCategoryList.length,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 1,
  //             childAspectRatio: 3 / 2,
  //             crossAxisSpacing: 14,
  //             mainAxisSpacing: 14,
  //             mainAxisExtent: 170.0),
  //         itemBuilder: (context, index) {
  //           return GestureDetector(
  //             onTap: () {
  //               Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                 return CategoryProducts(
  //                   category_id: homeData.featuredCategoryList[index].id,
  //                   category_name: homeData.featuredCategoryList[index].name,
  //                 );
  //               }));
  //             },
  //             child: Container(
  //               decoration: BoxDecorations.buildBoxDecoration_1(),
  //               child: Row(
  //                 children: <Widget>[
  //                   Container(
  //                       child: ClipRRect(
  //                           borderRadius: BorderRadius.horizontal(
  //                               left: Radius.circular(6), right: Radius.zero),
  //                           child: FadeInImage.assetNetwork(
  //                             placeholder: 'assets/placeholder.png',
  //                             image:
  //                                 homeData.featuredCategoryList[index].banner,
  //                             fit: BoxFit.cover,
  //                           ))),
  //                   Flexible(
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         homeData.featuredCategoryList[index].name,
  //                         textAlign: TextAlign.left,
  //                         overflow: TextOverflow.ellipsis,
  //                         maxLines: 3,
  //                         softWrap: true,
  //                         style:
  //                             TextStyle(fontSize: 12, color: MyTheme.font_grey),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //   } else if (!homeData.isCategoryInitial &&
  //       homeData.featuredCategoryList.length == 0) {
  //     return Container(
  //         height: 100,
  //         child: Center(
  //             child: Text(
  //           AppLocalizations.of(context).no_category_found,
  //           style: TextStyle(color: MyTheme.font_grey),
  //         )));
  //   } else {
  //     // should not be happening
  //     return Container(
  //       height: 100,
  //     );
  //   }
  //

  Widget buildHomeFeatureProductHorizontalList(HomePresenter homeData) {
    if (homeData.isFeaturedProductInitial == true &&
        homeData.featuredProductList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 160) / 3)),
        ],
      );
    } else if (homeData.featuredProductList.length > 0) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 248,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                homeData.fetchFeaturedProducts();
              }
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(18.0),
              separatorBuilder: (context, index) => SizedBox(
                width: 14,
              ),
              itemCount: homeData.totalFeaturedProductData >
                  homeData.featuredProductList.length
                  ? homeData.featuredProductList.length + 1
                  : homeData.featuredProductList.length,
              scrollDirection: Axis.horizontal,
              //itemExtent: 135,

              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return (index == homeData.featuredProductList.length)
                    ? SpinKitFadingFour(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    );
                  },
                )
                    : MiniProductCard(
                  id: homeData.featuredProductList[index].id,
                  image:
                  homeData.featuredProductList[index].thumbnail_image,
                  name: homeData.featuredProductList[index].name,
                  main_price:
                  homeData.featuredProductList[index].main_price,
                  stroked_price:
                  homeData.featuredProductList[index].stroked_price,
                  has_discount:
                  homeData.featuredProductList[index].has_discount,
                  is_wholesale:
                  homeData.featuredProductList[index].isWholesale,
                  discount: homeData.featuredProductList[index].discount,
                );
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).no_related_product,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    }
  }

  Widget buildHomeMenuRow1(BuildContext context, HomePresenter homeData) {
    return Row(
      children: [
        if (homeData.isTodayDeal)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TodaysDealProducts();
                }));
              },
              child: Container(
                height: 90,
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/todays_deal.png")),
                    ),
                    Text(AppLocalizations.of(context).todays_deal_ucf,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ),
          ),
        if (homeData.isTodayDeal && homeData.isFlashDeal) SizedBox(width: 14.0),
        if (homeData.isFlashDeal)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FlashDealList();
                }));
              },
              child: Container(
                height: 90,
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/flash_deal.png")),
                    ),
                    Text(AppLocalizations.of(context).flash_deal_ucf,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget buildHomeMenuRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /* Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CategoryList(
                  is_top_category: true,
                );
              }));
            },
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 3 - 4,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/top_categories.png")),
                  ),
                  Text(
                    AppLocalizations.of(context).home_screen_top_categories,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(132, 132, 132, 1),
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ),
        ),*/






        /*       Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  selected_filter: "brands",
                );
              }));
            },
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 3 - 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey,

              ),
              // decoration: BoxDecorations.buildBoxDecoration_1(
              // ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/brands.png")),
                  ),
                  Text(AppLocalizations.of(context).brands_ucf,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                          //color: Color.fromRGBO(132, 132, 132, 1),
                          fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        ),
        if(vendor_system.$)
          SizedBox(width: 10,),

        if(vendor_system.$)

        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TopSellingProducts();
              }));
            },
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 3 - 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey
              ),
              //decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/top_sellers.png")),
                  ),
                  Text(AppLocalizations.of(context).top_sellers_ucf,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        //color: Color.fromRGBO(132, 132, 132, 1),
                          fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        ),*/





      ],
    );
  }

  Widget buildHomeCarouselSlider(context, HomePresenter homeData) {
    if (homeData.isCarouselInitial && homeData.carouselImageList.length == 0) {
      return Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
          child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (homeData.carouselImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 351 /90,
            viewportFraction:1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInExpo,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              homeData.incrementCurrentSlider(index);
            }),
        items: homeData.carouselImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 0, bottom: 20),
                child: Stack(
                  children: <Widget>[
                    Container(
                      //color: Colors.amber,
                        width: double.infinity,
                        height: 140,
                        //decoration: BoxDecorations.buildBoxDecoration_1(),
                        child: AIZImage.radiusImage(i, 6)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: homeData.carouselImageList.map((url) {
                          int index = homeData.carouselImageList.indexOf(url);
                          return Container(
                            width: 7.0,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: homeData.current_slider == index
                                  ? MyTheme.white
                                  : Color.fromRGBO(112, 112, 112, .3),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      );
    } else if (!homeData.isCarouselInitial &&
        homeData.carouselImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  Widget buildHomeBannerOne(context, HomePresenter homeData) {
    if (homeData.isBannerOneInitial &&
        homeData.bannerOneImageList.length == 0) {
      return Padding(
          padding:
          const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 20),
          child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (homeData.bannerOneImageList.length > 0) {
      return Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 270 / 120,
              viewportFraction: .75,
              initialPage: 0,
              padEnds: false,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: true,
              onPageChanged: (index, reason) {
                // setState(() {
                //   homeData.current_slider = index;
                // });
              }),
          items: homeData.bannerOneImageList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 9.0, right: 9, top: 20.0, bottom: 20),
                  child: Container(
                    //color: Colors.amber,
                    width: double.infinity,
                    child: AIZImage.radiusImage(i, 6),
                  ),
                );
              },
            );
          }).toList(),
        ),
      );
    } else if (!homeData.isBannerOneInitial &&
        homeData.bannerOneImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }



  // Widget buildHomeBannerTwo(context, HomePresenter homeData) {
  //   if (homeData.isBannerTwoInitial &&
  //       homeData.bannerTwoImageList.length == 0) {
  //     return Padding(
  //         padding:
  //         const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 20),
  //         child: ShimmerHelper().buildBasicShimmer(height: 120));
  //   } else if (homeData.bannerTwoImageList.length > 0) {
  //     return Padding(
  //       padding: app_language_rtl.$
  //           ? const EdgeInsets.only(right: 9.0)
  //           : const EdgeInsets.only(left: 9.0),
  //       child: CarouselSlider(
  //         options: CarouselOptions(
  //             aspectRatio: 270 / 120,
  //             viewportFraction: .7,
  //             initialPage: 0,
  //             padEnds: false,
  //             enableInfiniteScroll: false,
  //             reverse: false,
  //             autoPlay: true,
  //             onPageChanged: (index, reason) {
  //               // setState(() {
  //               //   homeData.current_slider = index;
  //               // });
  //             }),
  //         items: homeData.bannerTwoImageList.map((i) {
  //           return Builder(
  //             builder: (BuildContext context) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(
  //                     left: 9.0, right: 9, top: 20.0, bottom: 20),
  //                 child: Container(
  //                   //color: Colors.amber,
  //
  //                   width: double.infinity,
  //                   child: AIZImage.radiusImage(i, 6),
  //                 ),
  //               );
  //             },
  //           );
  //         }).toList(),
  //       ),
  //     );
  //   } else if (!homeData.isBannerTwoInitial &&
  //       homeData.bannerTwoImageList.length == 0) {
  //     return Container(
  //         height: 100,
  //
  //         child: Center(
  //             child: Text(
  //               AppLocalizations.of(context).no_carousel_image_found,
  //               style: TextStyle(color: MyTheme.font_grey),
  //             )));
  //   } else {
  //     // should not be happening
  //     return Container(
  //       height: 100,
  //     );
  //   }
  // }


  Widget buildHomeBannerTwo(context, HomePresenter homeData) {
    if (homeData.isBannerTwoInitial && homeData.bannerTwoImageList.length == 0) {
      return Padding(
          padding:
          const EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 20),
          child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (homeData.bannerTwoImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 270 / 120,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInExpo,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason)
            {
              // homeData.incrementCurrentSlider(index);
            }
        ),
        items: homeData.bannerTwoImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 18, right: 18, top: 16, bottom: 20),
                child: Stack(
                  children: <Widget>[
                    Container(
                      //color: Colors.amber,
                        width: double.infinity,
                        height: 140,
                        //decoration: BoxDecorations.buildBoxDecoration_1(),
                        child: AIZImage.radiusImage(i, 6)),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: homeData.carouselImageList.map((url) {
                    //       int index = homeData.carouselImageList.indexOf(url);
                    //       return Container(
                    //         width: 7.0,
                    //         height: 7.0,
                    //         margin: EdgeInsets.symmetric(
                    //             vertical: 10.0, horizontal: 4.0),
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: homeData.current_slider == index
                    //               ? MyTheme.white
                    //               : Color.fromRGBO(112, 112, 112, .3),
                    //         ),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      );
    } else if (!homeData.isCarouselInitial &&
        homeData.carouselImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  // Widget buildHomeBannerTwo(context, HomePresenter homeData) {
  //   if (homeData.isBannerTwoInitial &&
  //       homeData.bannerTwoImageList.length == 0) {
  //     return Padding(
  //         padding:
  //             const EdgeInsets.only(left: 1.0, right: 1, top: 10, bottom: 10),
  //         child: ShimmerHelper().buildBasicShimmer(height: 120));
  //   } else if (homeData.bannerTwoImageList.length > 0) {
  //     return Padding(
  //       padding: app_language_rtl.$
  //           ? const EdgeInsets.only(right: 9.0)
  //           : const EdgeInsets.only(left: 9.0),
  //       child: CarouselSlider(
  //         options: CarouselOptions(
  //             aspectRatio: 270 / 120,
  //             viewportFraction: 0.7,
  //             enableInfiniteScroll: true,
  //             reverse: false,
  //             autoPlay: true,
  //             autoPlayInterval: Duration(seconds: 5),
  //             autoPlayAnimationDuration: Duration(milliseconds: 1000),
  //             autoPlayCurve: Curves.easeInExpo,
  //             enlargeCenterPage: false,
  //             scrollDirection: Axis.horizontal,
  //             onPageChanged: (index, reason) {
  //               // setState(() {
  //               //   homeData.current_slider = index;
  //               // });
  //             }),
  //         items: homeData.bannerTwoImageList.map((i) {
  //           return Builder(
  //             builder: (BuildContext context) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(
  //                     left: 9.0, right: 9.0, top: 20.0, bottom: 10),
  //                 child: Container(
  //                     width: 666,
  //                     child: AIZImage.radiusImage(i, 6)),
  //               );
  //             },
  //           );
  //         }).toList(),
  //       ),
  //     );
  //   } else if (!homeData.isCarouselInitial &&
  //       homeData.carouselImageList.length == 0) {
  //     return Container(
  //         height: 100,
  //         child: Center(
  //             child: Text(
  //           AppLocalizations.of(context).no_carousel_image_found,
  //           style: TextStyle(color: MyTheme.font_grey),
  //         )));
  //   } else {
  //     // should not be happening
  //     return Container(
  //       height: 100,
  //     );
  //   }
  // }

  // AppBar buildAppBar(double statusBarHeight, BuildContext context) {
  //   return AppBar(
  //     automaticallyImplyLeading: false,
  //     // Don't show the leading button
  //     backgroundColor: Colors.white,
  //     centerTitle: false,
  //     elevation: 0,
  //     flexibleSpace: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         GestureDetector(
  //           onTap: () {
  //             Navigator.push(context, MaterialPageRoute(builder: (context) {
  //               return Filter();
  //             }));
  //           },
  //           child: buildHomeSearchBox(context),
  //         ),
  //
  //         Icon(Icons.notifications),
  //
  //       ],
  //     ),
  //   );
  // }


  buildHomeSearchBox(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: Row(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 90, 30),
              child: GestureDetector(
                child: Image.asset(
                  'assets/menu1.png',
                  height: 50,
                  //color: MyTheme.dark_grey,
                  color: MyTheme.dark_grey,
                ),
                onTap: () {

                  print(scaffoldKey.currentState);
                  MainDrawer();
                  if(scaffoldKey.currentState.isDrawerOpen){
                    scaffoldKey.currentState.closeDrawer();
                  }else{
                    scaffoldKey.currentState.openDrawer();
                  }
                },

              ),

            ),

            Container(
                height: 180,
                margin: const EdgeInsets.fromLTRB(0, 0, 45, 0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Image.asset(
                          'assets/topbarlogo1.png',
                          //height: 40,
                          //width: 250,
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Filter()));
                    return;
                  },
                  child: Image.asset(
                    'assets/search.png',
                    height: 16,
                    //color: MyTheme.dark_grey,
                    color: MyTheme.dark_grey,
                  ),

                )
            ),

            InkWell(
                onTap: (){
                },
                child: Icon(Icons.notifications)),

            // Container(
            //   margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            //   child: Stack(
            //     children: [
            //       Container(
            //           child: GestureDetector(
            //             onTap: () {
            //               Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
            //               return;
            //             },
            //             child: badges.Badge(
            //               badgeStyle: badges.BadgeStyle(
            //                 shape: badges.BadgeShape.circle,
            //                 badgeColor: MyTheme.accent_color,
            //                 borderRadius: BorderRadius.circular(10),
            //                 padding: EdgeInsets.all(5),
            //               ),
            //               badgeAnimation: badges.BadgeAnimation.slide(
            //                 toAnimate: false,
            //               ),
            //               child: Image.asset(
            //                 "assets/cart.png",
            //                 color: badgeNo == 2
            //                     ? MyTheme.accent_color
            //                     : Color.fromRGBO(153, 153, 153, 1),
            //                 height: 16,
            //               ),
            //               badgeContent: Consumer<CartCounter>(
            //                 builder: (context, cart, child) {
            //                   return Text(
            //                     "${cart.cartCounter}",
            //                     style:
            //                     TextStyle(fontSize: 10, color: Colors.white),
            //                   );
            //                 },
            //               ),
            //             ),
            //           )
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),

    );
  }


  /* buildHomeSearchBox(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).search_anything,
              style: TextStyle(fontSize: 13.0, color: MyTheme.textfield_grey),
            ),
            Image.asset(
              'assets/search.png',
              height: 16,
              //color: MyTheme.dark_grey,
              color: MyTheme.dark_grey,
            )
          ],
        ),
      ),
    );
  }*/






  CustomScrollView buildBodyChildren() {
    return CustomScrollView(
      //controller: _mainScrollController,
      physics:
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            buildSettingAndAddonsHorizontalMenu(),

          ]),
        )
      ],
    );
  }







  showLoginWarning() {
    return ToastComponent.showDialog(
        AppLocalizations.of(context).you_need_to_log_in,
        gravity: Toast.center,
        duration: Toast.lengthLong);
  }
  Container buildProductLoadingContainer(HomePresenter homeData) {
    return Container(
      height: homeData.showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
            homeData.totalAllProductData == homeData.allProductList.length
                ? AppLocalizations.of(context).no_more_products_ucf
                : AppLocalizations.of(context).loading_more_products_ucf),
      ),
    );
  }

  Container buildSettingAndAddonsHorizontalMenuItem(
      String img, String text, Function() onTap) {
    return Container(
      alignment: Alignment.center,
      // color: Colors.red,
      // width: DeviceInfo(context).width / 4,
      child: InkWell(
        onTap: is_logged_in.$
            ? onTap
            : () {
          showLoginWarning();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              img,
              width: 20,
              height: 20,
              color: is_logged_in.$
                  ? Colors.black
                  : MyTheme.medium_grey_50,
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // Text(
            //   text,
            //   textAlign: TextAlign.center,
            //   maxLines: 1,
            //   style: TextStyle(
            //       color: is_logged_in.$
            //           ? MyTheme.dark_font_grey
            //           : MyTheme.medium_grey_50,
            //       fontSize: 12),
            // )
          ],
        ),
      ),
    );
  }
  Widget buildSettingAndAddonsHorizontalMenu() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 20,horizontal: 16),
      //margin: EdgeInsets.only(top: ),
      //width: DeviceInfo(context).width,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: GridView.count(
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 3,
        // ),
        crossAxisCount: 1,

        childAspectRatio: 1,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        cacheExtent: 5.0,
        mainAxisSpacing: 16,
        children: [

          buildSettingAndAddonsHorizontalMenuItem(
              "assets/icons/wishicon.png",
              AppLocalizations.of(context).my_wishlist_ucf,
              is_logged_in.$
                  ? () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return Wishlist();
                    }));
              }
                  : () => null),

        ],
      ),
    );
  }



  //
  // Widget notificationcount() {
  //   bool isExpanded = false;
  //   return FutureBuilder(
  //     future: notification_count(),
  //     builder: (context, snapshot) {
  //       print("object");
  //
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Container(
  //           child: Center(child: CircularProgressIndicator()),
  //         );
  //       } else if (snapshot.hasError) {
  //         return Container(
  //           child: Center(child: Text("No more notification")),
  //         );
  //       } else if (snapshot.hasData) {
  //         if (snapshot.data != null && snapshot.data.data != null) {
  //           print(snapshot.data.data.length);
  //           print("object");
  //
  //           return Container(
  //             padding: EdgeInsets.only(left: 16, right: 16),
  //             child: Column(
  //               children: [
  //                 ListView.separated(
  //                   shrinkWrap: true,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   itemBuilder: (context, int index) {
  //                     return
  //
  //                       InkWell(
  //                         onTap: () {
  //                           print("govind kkk");
  //                         },
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(12.0),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.black.withOpacity(0.2),
  //                                 spreadRadius: 2,
  //                                 blurRadius: 4,
  //                                 offset: Offset(0, 3),
  //                               ),
  //                             ],
  //                           ),
  //                           child: Container(
  //                             padding: EdgeInsets.all(8.0),
  //                             child: Column(
  //                               children: [
  //                                 Row(
  //                                   mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Row(
  //                                       children: [
  //                                         Text("Notification Count:"),
  //                                         SizedBox(width: 5,),
  //                                        // Text(snapshot.data.unreadNotificationCount.toString()),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //
  //
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                   },
  //                   separatorBuilder: (context, index) {
  //                     return SizedBox(height: 16);
  //                   },
  //                   itemCount:0
  //                   //snapshot.data.length,
  //                 ),
  //               ],
  //             ),
  //           );
  //         } else {
  //           return Container(
  //             child: Center(child: Text("No data available")),
  //           );
  //         }
  //       } else {
  //         return Container(
  //           child: Center(child: CircularProgressIndicator()),
  //         );
  //       }
  //     },
  //   );
  // }

  Future<NotificationCountModel> notification_count() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'XSRF-TOKEN=eyJpdiI6IlFyRFh3Qkk4dzVaNGN6dm9MWlh1c3c9PSIsInZhbHVlIjoiZlJqbW9MK3pnOTJsdU13ejZ1OGN3ekFvNFBTS1BwSWl1WWZKUERHTHVnTjZnWGRQeUNMQzBiOEVCaHl5TzhiditPK3UyUjBsUzY1TlBtRk5DRGFCVEpxMS8yMSsySXlSdmZTK2NMODRwUXJSL1RENkdNYm5KQ2p5Y0FSaEhHUG4iLCJtYWMiOiJkYTM2Njk3MDc1MGExZGRjNjgxYjVlYmM3MTEzNWUyMTgwMmY2ZmI5NjdlNWM2MGNhYWE5NmMzNmZiODkwNDJhIiwidGFnIjoiIn0%3D; umonda_online_marketplace_session=eyJpdiI6IkhFRkJlNEFFNE96NWV3Y0xoT3M4Qnc9PSIsInZhbHVlIjoiNUdPbnVNcjR5SG9xRndCeHBpbDZKQWZKNVVyUm5nQnY3ZmQ0UTlLSk5kTEI5UGs0UVpqWTFub3V6SkJZTTJFNDhJNmwybXN6NmlHdnh4RVBiejZBZ2hZVVZmbWtaTEpmUkpSUG4weDFOVWlSbjRVeWZHQnNmc0hDQnZzaFVsSnUiLCJtYWMiOiJmMjAxYjE0Y2QzNTMzNjQzMWM1ZGJkMmZjZGJkNjg4Mjk2MTAyMzRkOTZkMjIzNTQyMmRmMmQwNWQ5NTc5YjZjIiwidGFnIjoiIn0%3D'
    };
    var data = json.encode({
      "id": user_id.$,
      //"id": 198,
    });
    var dio = Dio();
    var response = await dio.request(
      //"${AppConfig.RAW_BASE_URL}/notificationsCount",

      //'https://webcluestechnology.com/demo/erp/umonda/api/v2/notificationsCount',
      'https://umonda.com/api/v2/notificationsCount',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,

    );

    if (response.statusCode == 200) {
      // print(json.encode(response.data));
      print("notification count");
      print(response.data);
      savecount=response.data;
      print("save count variable ${savecount}");

      print("Notification count response: ${response.data}");

      // Assuming response.data is a map like {'unread_notification_count': 1}
      int numericValue = response.data['unread_notification_count'] ?? 0;

      print("Numeric value: $numericValue");

      print("only number ${numericValue}");
      notificationnumber=numericValue.toString();// Output: 1
      print("onlynummmm ${notificationnumber}"); // Output: 1

      //globalResponseBody=response.data;
      //print("Global data:: ${globalResponseBody}");
      return NotificationCountModel.fromJson(response.data);
      print("purchase package");
      //print(response.data);
    }
    else {
      print(response.statusMessage);
    }
  }

}