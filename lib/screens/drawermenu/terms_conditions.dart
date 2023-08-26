import 'package:flutter/material.dart';
import 'package:hardware_lo/custom/useful_elements.dart';

class TermsConditions extends StatelessWidget {
  //const TermsConditions({super.key});

  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(

        children: [
          Container(
            padding: EdgeInsets.only(top: 15.0, bottom: 5),
            child: Image.asset('assets/appbarlogo.png',
              height: 70,
              width: 100,),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Overview",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 113, 112, 112))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("This document is an electronic record in terms of Information Technology Act, 2000 and rules there under as applicable and the amended provisions pertaining to electronic records in various statutes as amended by the Information Technology Act, 2000. This electronic record is generated by a computer system and does not require any physical or digital signatures.",
                style: TextStyle(fontSize: 20,
                    color: Colors.black)),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("This document is an electronic record in terms of Information Technology Act, 2000 and rules there under as applicable and the amended provisions pertaining to electronic records in various statutes as amended by the Information Technology Act, 2000. This electronic record is generated by a computer system and does not require any physical or digital signatures.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("This document is published in accordance with the provisions of Rule 3 (1) of the Information Technology (Intermediaries guidelines) Rules, 2011 that require publishing the rules and regulations, Privacy Policy and Terms of Use for access or usage of this website.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),

          Container(
            margin: EdgeInsets.all(10.0),
            child: Text.rich(TextSpan(
                children: [
                  TextSpan(text: 'This website ', style: TextStyle(fontSize: 20)),
                  TextSpan(text: 'www.umonda.com', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 15, 22, 249))),
                  TextSpan(text: ' is owned and operated by UMONDA LLC. By using this website, you agree to be bound to these Terms and Conditions. Please read them carefully.',
                          style: TextStyle(fontSize: 20)),
                ]
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Website and App Access",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("UMONDA LLC grants you a limited, revocable permit to access and make personal use of this website as our customer. However, you are not permitted to:",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Reproduce, duplicate, copy, sell or otherwise exploit this website or any product image, product listing, product description, price, page layout, page design, trade dress, trademark, logo or other content (“Website Content”) for any commercial purpose, except as expressly provided;",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Use of robot, spider, data mining, extraction tool or process to monitor, extract or copy Website Content (except in the operation or use of internet 'search engines', hit counters or similar technology);",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Use of any meta tags, search terms, key terms, or usage of website’s name or trademarks.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Engage in any activity that interferes with the website or another user’s ability to use the website;",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Modify, create derivative works from reverse engineer, decompile or disassemble any technology used to provide the website and the services offered on the website; or,",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Assist or encourage any third party in engaging in any activity prohibited by these Terms of Use.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Any use of this website or website content that is not expressly authorized herein is prohibited and immediately terminates the permission granted.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Communications",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("You agree to receive communications from us via email, messages and app notifications. You agree that all agreements, notices, disclosures and other communications that UMONDA LLC provides to you by email satisfy any legal requirement that will be in writing.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Your Account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("By using this website or app, you are responsible for maintaining the confidentiality of your account and password and for restricting access to your account. You agree to accept responsibility for all activities that occur under your account or password. UMONDA LLC reserves the right to refuse services, terminate accounts, remove, edit content, or cancel orders in our sole discretion.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Your Orders",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("UMONDA LLC has full rights to cancel/reschedule orders without confirming with a customer or blocking him/her from our delivery list. For Cash on Delivery (COD) orders of more than AED 1000.00, the address verification is done prior to the delivery of goods.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Your Payments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("UMONDA LLC as a merchant platform shall be under no liability whatsoever in respect of any loss or damage arising directly or indirectly out of the decline of authorization for any transaction, or if the account of the Cardholder has exceeded the preset limit mutually agreed by us with our payment partner or acquiring bank.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Payment Policy",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("After purchasing an item, payments shall be done within 3 business days to our account via bank transfer, PayPal or Debit/Credit Card. Buyer shall pay purchase price plus 5% commission, which includes delivery charges. Dismantling and Assembly of certain items will include an additional charge of 100.00 AED (optional). Non-payments will result in reminders, and eventually blocking of the respective user from our platform.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text.rich(TextSpan(
                children: [
                  TextSpan(text: "Payment to the seller is the selling price minus 5% selling fees on sale price, and will be credited to the seller's UMONDA Wallet, once our courier partner has picked up the item. Seller has the option to withdraw payments from his UMONDA Wallet at any time via available payment channels. Funds may remain in the seller's UMONDA Wallet for an unlimited time, and can be used for purchases of products offered on ",
                      style: TextStyle(fontSize: 20)),
                  TextSpan(text: 'www.umonda.com.', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 15, 22, 249))),
                  TextSpan(text: " Payment currency is AED.",
                      style: TextStyle(fontSize: 20)),
                ]
            )
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Return Policy",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("There are no returns on purchasing used/pre-owned items.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Promotional Offer",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("We may disclose to third-party services certain personally identifiable information listed below:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Any misuse of promotional offers will result in users being blocked and promotional amounts being reversed or deducted.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Copyright",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Website and App Content is property of UMONDA LLC and is protected by copyright laws. The purchase of any product does not provide the purchaser with any copyright interest or other intellectual property right in the product. All Website Content that is not UMONDA LLC property is used with permission.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Trademarks",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Certain graphics, logos, page headers, button icons, scripts, service names, trademarks and service marks, are property of UMONDA LLC or our affiliated companies. UMONDA LLC trademarks and trade dress may not be used for any commercial or other purposes without prior written consent.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Complaints",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("UMONDA LLC honors the intellectual property rights of others. If you believe that your work has been copied or used on this website in a way that constitutes copyright or trademark infringement, please notify us by sending an email to info@umonda.com. Except in limited instances under authorized agreements, we do not reproduce or manufacture the products offered on our site. We offer a platform for third parties to display and sell their products on this website. Upon receipt of any bona fide claim of infringement, or upon becoming aware of any actual or alleged infringement by any other means, we will remove such actual or alleged infringing product(s) from this website and/or cease sales of the product(s) pending our investigation.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Limitation of Liability",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("UMONDA LLC cannot guarantee or take responsibility that this Website or App, its servers, or email sent from the website are free of viruses or other harmful components. UMONDA LLC will not be liable for any damages of any kind arising from the use of this website, including, but not limited to direct, indirect, incidental, punitive or consequential damages.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Applicable Law",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("By visiting this Website or App, you agree that the laws of UAE, without regard to principles of conflict of laws, will govern these Terms of Use and any dispute of any sort that might arise between you and UMONDA LLC relating to the use of this website.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text("Change without notice and Severability",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 60),
            child: Text("UMONDA LLC reserves the right to make changes to this site, policies, and these Terms of Use at any time and in our sole discretion; therefore, you should review our policies, terms, and conditions each time you visit this website. Your continued use of this website after we make any such changes constitutes your binding acceptance of those changes. If any of the terms or conditions herein shall be deemed invalid, void, or for any reason unenforceable, that term or condition shall be deemed severable and shall not affect the validity and enforceability of any remaining term or condition.",
                style: TextStyle(fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),

        ],
      ),

    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Color.fromARGB(240, 243, 237, 237),
      title: buildAppBarTitleOption(context),
      elevation: 0.0,
      titleSpacing: 0,

    );
  }

  Widget buildAppBarTitleOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Container(
            width: 20,
            // child: UsefulElements.backButton(context, color: "white"),
          ),
          Container(
            padding: EdgeInsets.only(left: 0),

            child: Text('Terms & Conditions',
              style: TextStyle(color:  Colors.black,),
          ),
          )

        ],
      ),
    );
  }
}