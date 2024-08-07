import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:umonda/custom/device_info.dart';
import 'package:umonda/my_theme.dart';
import 'package:umonda/custom/useful_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:umonda/repositories/brand_repository.dart';
import '../Social_Login/googleloginn.dart';
import '../custom/btn.dart';
import '../data_model/AllCategoryResponse.dart';
import '../app_config.dart';
import '../helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import '../screens/common_webview_screen.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/main.dart';

class placead extends StatefulWidget {
  String catevale;

  placead({Key key,this.catevale}) : super(key: key);

  @override
  State<placead> createState() => _placeadState();
}

class _placeadState extends State<placead> {
  bool _obscureText = true;
  bool _isUploading = false;
  bool _isAgree = false;
  bool light = false, isChecked = true;
  bool _filteredBrandsCalled = false;
  bool _filteredcategoryCalled = false;
  List<File> basee = [];
  List<dynamic> brandsList = [];
  final picker = ImagePicker();
  String imageurl;
  String dropdownBrands = "Select Select_Brand";
  String dropdownCategory = "Select Select_Category";
  bool isEnabled = false;
  String offerstatus="0";
  String allurlss;
  String image;
  List<File> selectedImages = []; // List to hold selected image files
  List<String> imageUrls = [];
  List<String> base64Urls = [];
  bool _customeIcon = false;
  String globalResponseBody;

  TextEditingController _ProductName = TextEditingController();
  TextEditingController _Category = TextEditingController();
  TextEditingController _Brand = TextEditingController();
  TextEditingController _PriceAED = TextEditingController();
  TextEditingController _MinOfferPrice = TextEditingController();
  TextEditingController _Description = TextEditingController();
  TextEditingController _EmailID = TextEditingController();
  TextEditingController _PassWord = TextEditingController();
  TextEditingController _offerControler = TextEditingController();
  List<String> selectedItems = [];
  List<bool> isCheckedList = [];
  List<allcategoryModel> itemList = [];
  String ProductID;
  List<String> selectedProductIDs = [];

  @override
  void initState() {
    fetch_Brands();
    super.initState();
  }

  fetch_Brands() async {
    var filteredBrandResponse = await BrandRepository().getFilterPageBrands();
    brandsList.addAll(filteredBrandResponse.brands);
    print("placead.dart, fetch_Brands(), brandsList : ${filteredBrandResponse.brands}");
    _filteredBrandsCalled = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: MyCustomForm(),
    ));
  }

  Widget MyCustomForm() {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody()
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //iconTheme: IconThemeData(color: Colors.black),
      leading: UsefulElements.backToMain(context, go_back: false,color:Colors.black),
      backgroundColor: Color.fromARGB(240, 243, 237, 237),
      title: buildAppBarTitleOption(context),
      elevation: 0.0,
      titleSpacing: 0,

    );
  }

  Widget buildAppBarTitleOption(BuildContext context) {
    print("Govind>>>>> ${ProductID}");
    print("Selected ProductIDs>>>>>>>>>>>>: $selectedProductIDs");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          // Text(widget.catevale),
          Container(
            width: 20,
            // child: UsefulElements.backButton(context, color: "white"),
          ),
          Container(
            padding: EdgeInsets.only(left: 0),

            child: Text('Place Ad',
              style: TextStyle(color: Colors.black,),
            ),
          )

        ],
      ),
    );
  }

  Widget buildBody() {
    bool light = false;
    return
      ListView(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Ad Information",
                              style: TextStyle(fontSize: 14,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: TextField(
                        controller: _ProductName,
                        autofocus: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Product Name',
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),

                    ExpansionTile(title: Text("Category"),
                      children: [
                        ListTile(
                          title: InkWell(onTap: (){
                          },
                            child: listviewallcategories(),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded){
                        // setState(() => _customeIcon = expanded);
                      },

                    ),
                   // Divider(thickness: 1.2,color: Colors.black,),

                    Container(
                        margin: const EdgeInsets.fromLTRB(5, 6, 0, 0),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Brand",
                              style: TextStyle(fontSize: 14,
                                  color: Color.fromARGB(255, 0, 0, 0))
                          ),
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      alignment: Alignment.topLeft,
                      child: BrandDropdown(),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    // ),

                  ],
                ),
              ),
            ),

            //-------------------
            Container(
              margin: const EdgeInsets.fromLTRB(5, 2, 5, 0),
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Ad Image",
                              style: TextStyle(fontSize: 14,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                        )
                    ),
                    Container(
                      // alignment: Alignment.center,
                      child: Center(
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white)),
                              child: const Text('Select Image from Gallery',
                                  style: TextStyle(fontSize: 14,
                                      color: Color.fromARGB(255, 104, 104, 104))),
                              onPressed: () {
                                getImages();
                              },
                            ),

                            SizedBox(
                              height: 100,
                              //width: 20,
                              child: selectedImages.isEmpty
                                  ?  Center(child: Text('Sorry nothing selected!!'))
                                  :
                              GridView.builder(
                                itemCount: selectedImages.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  print("Placead.dart, index : ${index}");
                                  print("PlaceadGGG ${selectedImages}");

                                  print("base 64 ${basee}");
                                  return Center(
                                    child: Stack(
                                      children: [
                                        Container(
                                          // width: 200,
                                          //height: 10880,
                                          alignment: Alignment.center,
                                          child: Image.file(selectedImages[index],fit: BoxFit.cover,),
                                        ),
                                        Positioned(
                                          top: 2, right: 20,
                                          child: GestureDetector(
                                            child: Icon(Icons.close, size: 30, color: Colors.red,),
                                            onTap: (){
                                              delete(index);
                                            },
                                          ),
                                        ),
                                      ],
                                      //child: Image.file(selectedImages[index])
                                    ),
                                  );
                                },
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
            //---------------------
            if (_isUploading)
              Center(
                child: CircularProgressIndicator(),
              ),

            Container(
              margin: const EdgeInsets.fromLTRB(5, 2, 5, 0),
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Ad Price",
                              style: TextStyle(fontSize: 14,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: TextField(
                        controller: _PriceAED,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Price in AED',
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text("Make an offer",
                                  style: TextStyle(fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0))),
                              Switch(
                                value: isEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isEnabled = value;
                                    offerstatus=isEnabled ? '1' : '0';
                                    print("Switch value${offerstatus}");
                                    if (isEnabled) {
                                      print('Switch is enabled');
                                    } else {
                                      print('Switch is disabled');
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          //SizedBox(height: 20.0),

                          isEnabled ?

                          Container(
                            child: TextField(
                              controller: _offerControler,

                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Offer',
                              ),
                              keyboardType: TextInputType.number,
                              minLines: 1,
                              maxLines: 11,
                            ),
                          ) :Column()
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(5, 2, 5, 0),
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(5, 6, 0, 0),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Ad Description",
                              style: TextStyle(fontSize: 14,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 2, 5, 0),
                      child: TextField(
                        controller: _Description,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Description',
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0,left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    child: Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        value: _isAgree,
                        onChanged: (newValue) {
                          _isAgree = newValue;
                          setState(() {});
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(
                      width: DeviceInfo(context).width - 130,
                      child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                              style: TextStyle(
                                  color: MyTheme.font_grey, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: "I agree to the",
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommonWebviewScreen(
                                                    page_name:
                                                    "Terms Conditions",
                                                    url:
                                                    "${AppConfig.RAW_BASE_URL}/mobile-page/terms",
                                                  )));
                                    },
                                  style:
                                  TextStyle(color: MyTheme.accent_color),
                                  text: " Terms Conditions",
                                ),
                                TextSpan(
                                  text: " &",
                                ),
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
                                                    "${AppConfig.RAW_BASE_URL}/mobile-page/privacy-policy",
                                                  )));
                                    },
                                  text: " Privacy Policy",
                                  style:
                                  TextStyle(color: MyTheme.accent_color),
                                )
                              ])),
                    ),
                  )
                ],
              ),
            ),




            Padding(
              padding: const EdgeInsets.only(top: 20.0,left: 16,right: 16),
              child: Container(
                height: 45,
                child: Btn.minWidthFixHeight(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(6.0))),
                  child: Text(
                    "Upload Ad",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: _isAgree
                      ? () {
                    if (_ProductName.text.isEmpty ||
                        dropdownCategory.isEmpty ||
                        dropdownBrands.isEmpty ||
                        _Description.text.isEmpty ||
                        _PriceAED.text.isEmpty
                    )

                    {
                      print("images url${imageurl}");
                      Fluttertoast.showToast(
                        msg: "Please fill in all fields",
                        // toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black87,
                        textColor: Colors.red,
                        fontSize: 16.0,
                      );
                    }
                    else {
                      String selectedProduct = selectedProductIDs.map((item) => item.toString()).join(',').replaceAll(', ', ',');
                      String selectedPro = selectedItems.map((item) => item.toString()).join(',').replaceAll(', ', ',');

                      print("category  remove square renove space....:${selectedProduct}");

                      var ProdName = _ProductName.text.toString();

                      var category = selectedPro;
                      var brand = dropdownBrands.split(" ")[0].toString();
                      var description = _Description.text.toString();
                      var amount = _PriceAED.text.toString();
                      var email = _EmailID.text.toString();
                      var password = _PassWord.text.toString();
                      var offer = _offerControler.text.toString();
                      // var imagebase = imageurl;
                      var imagebase = allurlss;
                      var userid = user_id.$;
                      //var imagebase = allurlss;


                      print("Product name.: ${ProdName}");
                      print("category.....: ${category}");
                      print("Brand........: ${brand}");
                      print("Description..: ${description}");
                      print("Amount.......: ${amount}");
                      print("Email........: ${email}");
                      print("password.....: ${password}");
                      print("****************************************************************");

                      print("Base 64 url....: ${imagebase}");
                      print("::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");

                      print("Base 64 url....: ${allurlss}");
                      print("****************************************************************");
                      print("User id  .....: ${user_id.$}");
                      print("Offer price  .....: ${offer}");
                      print("Offer Status  .....: ${offerstatus}");
                      print("URLLLLLLLL  .....: ${base64Urls}");
                      print("IMAGE_URLLLLL  .....: ${imageUrls}");
                      print("Select Images  .....: ${selectedImages}");

                      place_ad_upload(ProdName,category,brand,description,offer,amount,offerstatus,email,password);
                      setState(() {
                        // printSelectedItems();
                        _isAgree = false;

                      });



                    }
                  }
                      : null,
                ),
              ),
            ),

            SizedBox(height: 5,),
          ]
      );
  }

  BrandDropdown() {
    print("placead.dart, BrandDropdown(), dropdownBrands : ${dropdownBrands}");
    return DropdownButton2<dynamic>(
      hint: Text(dropdownBrands.split(" ")[1],style: TextStyle(color: Colors.black),),

      isExpanded: true,
      // value: dropdownBrands,
      icon: const Icon(Icons.keyboard_arrow_down, size: 35,),
      //elevation: 5,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 1,
        color: Colors.black,
      ),

      onChanged: (value) {
        // This is called when the user selects an item.
        dropdownBrands = value;
        setState(() {
          print("Selected city is $value");
          dropdownBrands = value;
        });
      },
      items: brandsList.map((brands) {
        print("Brands List${dropdownBrands}");
        print("brands ID ${brands.id}");
        return DropdownMenuItem(
          value: "${brands.id.toString()+" "+brands.name.toString()}",
          child: Text(brands.name.toString(), style: TextStyle(fontSize: 14),),
        );
      }).toList(),
    );
  }

  Future<void> getImages() async {
    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    setState(() {
      if (pickedFiles.isNotEmpty) {
        for (var i = 0; i < pickedFiles.length; i++) {
          selectedImages.add(File(pickedFiles[i].path));
          print("Select images${selectedImages}");
        }
        // Create a list to store image paths in the desired format
        List<String> imagePaths = [];
        // Append selected image paths to the list
        for (var image in selectedImages) {
          String imagePath = image.path.replaceAll('\\', '/');
          imagePaths.add(imagePath);
          imageUrls=imagePaths;
          // print('Selected Image Path: $imagePath');
        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')),
        );
      }
    });
  }

  void delete(int index){
    setState(() {
      selectedImages.removeAt(index);
      print("tile number#$index is deleted");

    });
  }

  place_ad_upload(name,Category,Brand,description,offer,amount,offerstatus,email,password) async {

    setState(() {
      _isUploading = true;
    });

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your_access_token_here', // Replace with your actual token
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConfig.BASE_URL}/product/add'),
    );

    request.fields.addAll({

      'name': name,
      'user_id': user_id.$.toString(),
      'category_id':Category,
      'brand_id':Brand,
      'filename': 'welcome',
      'description': description,
      'min_offer_price':offer,
      'unit_price': amount,
      'moffer': offerstatus,
      'email':email,
      'password':password

    });

    for(var i=0;i<imageUrls.length;i++)
    {
      request.files.add(await http.MultipartFile.fromPath('thumbnail_img[]', imageUrls[i],));


    }

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        Fluttertoast.showToast(
          msg: "Product Add successfully",
          //toastLength:LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // You can change the position
          timeInSecForIosWeb: 1, // Duration in seconds the toast should be visible on iOS and web
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.green, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );

        _ProductName.clear();
        _Description.clear();
        _PriceAED.clear();
        _EmailID.clear();
        _PassWord.clear();
        _offerControler.clear();

        for (int i = 0; i < isCheckedList.length; i++) {
          isCheckedList[i] = false;
        }
        setState(() {
          // printSelectedItems();
          _isAgree = false;
          isEnabled = false;
          selectedImages.clear();
          selectedItems.clear();
          dropdownBrands =  dropdownBrands="Select Select_Brand";
        });

        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return Main(go_back: false,);
          },
          ),(route)=>false,);

      }
      else if(response.statusCode == 401)
      {
        print("Unauthorized user");
        Fluttertoast.showToast(
          msg: "Unauthorized user",
          //toastLength:LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // You can change the position
          timeInSecForIosWeb: 1, // Duration in seconds the toast should be visible on iOS and web
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.red, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
      }
      else {
        print('HTTP Error: ${response.statusCode}');
        print(await response.stream.bytesToString());
        Fluttertoast.showToast(
          msg: "Unauthorized fields",
          //toastLength:LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // You can change the position
          timeInSecForIosWeb: 1, // Duration in seconds the toast should be visible on iOS and web
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.red, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() {
      _isUploading = false;
    });
  }

  Widget listviewallcategories() {
    return
      FutureBuilder(
        future: fetchDataallcategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            title: Text(snapshot.data[index].name.toString()),
                            value: selectedItems.contains(snapshot.data[index].id.toString()),
                            onChanged: (value) {
                              setState(() {
                                if (value) {
                                  selectedItems.add(itemList[index].id.toString());
                                } else {
                                  selectedItems.remove(itemList[index].id.toString());
                                }
                              });

                              // Handle checkbox state changes here.
                              // You can add or remove the item from the selectedItems list.
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero, // Move checkbox to the left side.
                          ),
                        //  SizedBox(height: 1),

                            Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: ListView.builder(
                              itemCount: itemList[index].childrenCategories.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, int subindex) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CheckboxListTile(
                                      title: Text(itemList[index].childrenCategories[subindex].name.toString()),
                                      value: selectedItems.contains(itemList[index].childrenCategories[subindex].id.toString()),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value) {
                                            selectedItems.add(itemList[index].childrenCategories[subindex].id.toString());
                                          } else {
                                            selectedItems.remove(itemList[index].childrenCategories[subindex].id.toString());
                                          }
                                        });

                                        // Handle checkbox state changes here.
                                      },
                                      controlAffinity: ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.zero, // Move checkbox to the left side.
                                    ),
                                   // SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: ListView.builder(
                                        itemCount: itemList[index].childrenCategories[subindex].categories.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, int catindex) {
                                          return CheckboxListTile(
                                            title: Text(itemList[index].childrenCategories[subindex].categories[catindex].name.toString()),
                                            value: selectedItems.contains(itemList[index].childrenCategories[subindex].categories[catindex].id.toString()),
                                            onChanged: (value) {

                                              setState(() {
                                                if (value) {
                                                  selectedItems.add(itemList[index].childrenCategories[subindex].categories[catindex].id.toString());
                                                } else {
                                                  selectedItems.remove(itemList[index].childrenCategories[subindex].categories[catindex].id.toString());
                                                }
                                              });

                                              // Handle checkbox state changes here.
                                            },
                                            controlAffinity: ListTileControlAffinity.leading,
                                            contentPadding: EdgeInsets.zero, // Move checkbox to the left side.
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: itemList.length,
                  ),
                ],
              ),
            );
          } else {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      );
  }

  Future<List<allcategoryModel>> fetchDataallcategories() async {
    var url = Uri.parse('${AppConfig.BASE_URL}/all-categories');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      globalResponseBody = response.body; // Assign the response body to the global variable

      List<dynamic> jsonList = json.decode(globalResponseBody);

      itemList = jsonList.map((json) => allcategoryModel.fromJson(json)).toList();

      print("allcategoryModel Response > ${itemList.length}");

      return itemList;
    } else {
      throw Exception('Failed to load data');
    }
  }
}