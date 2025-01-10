import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: const Text(
          "About us",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 25,
              UiConstant.horizontalPadding, 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(AppUiImage.kuduLogo),
                const SizedBox(height: 20),
                const MarkdownBody(data: _content)
              ],
            ),
          )),
    );
  }

  static const _content = '''

Welcome to **Kudu Mart**, a revolutionary platform designed to connect sellers and buyers effortlessly. At Kudu Mart, we believe in empowering entrepreneurs and simplifying the shopping experience for everyone.

### Our Mission  
To provide a seamless and secure platform where vendors can showcase their products to a vast audience, and buyers can discover quality items with ease. We aim to foster trust and transparency in every transaction.

### What We Offer  
- **For Vendors**: The ability to create and manage multiple virtual stores, reach potential buyers, and grow your business. With a simple subscription model, we ensure your products get the visibility they deserve.  
- **For Buyers**: Access to a diverse range of products, user-friendly browsing, and the opportunity to connect directly with trusted vendors.  

### Why Choose Kudu Mart?  
- **Simple and Intuitive**: Our platform is easy to use, ensuring a hassle-free experience for both vendors and buyers.  
- **Wide Reach**: Vendors can showcase their products to thousands of potential customers.  
- **Secure Platform**: Your data and transactions are protected with the highest standards of security.  
- **Community-Oriented**: We’re dedicated to creating a trusted and vibrant marketplace for all.  

### Join Us  
Whether you’re a seller looking to grow your business or a buyer searching for great products, Kudu Mart is here to meet your needs. Together, let’s redefine how we connect, shop, and grow.  

''';
}
