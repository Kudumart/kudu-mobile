import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';

import '../../core/constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 0,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        leading: const AppBackButton(),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
            horizontal: UiConstant.horizontalPadding, vertical: 20),
        child: Markdown(data: _privacyPolicyMarkdownText),
      ),
    );
  }

  static const String _privacyPolicyMarkdownText = '''
_Last Updated: [29/11/2024]_

Kudu Mart values your privacy. This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use our app.
  
  
## 1. Information We Collect
We collect the following types of information:

a. **Information You Provide Directly**
- Name, email address, and phone number when you register as a user or vendor.
- Payment information when you subscribe as a vendor.
- Product details and descriptions when vendors create virtual stores.

b. **Automatically Collected Information**
- Device information such as IP address, operating system, and browser type.
- Usage data, including the pages you visit and features you use within the app.

c. **Cookies and Tracking Technologies**
We may use cookies and similar technologies to enhance your experience and improve our services.



## 2. How We Use Your Information
We use your information to:

- Provide, operate, and improve Kudu Mart’s services.
- Facilitate transactions between buyers and vendors.
- Communicate updates, promotions, and important notifications.
- Prevent fraud and ensure security.



## 3. How We Share Your Information
We do not sell your information to third parties. However, we may share your information in the following circumstances:

- **With Vendors:** Registered buyers’ information may be shared with vendors for transaction purposes.
- **With Service Providers:** Third-party providers assisting in payment processing, hosting, and analytics.
- **As Required by Law:** To comply with legal obligations or respond to lawful requests from authorities.



## 4. Data Retention
We retain your information for as long as necessary to provide services or comply with legal requirements. You can request the deletion of your data by contacting us.



## 5. Security
We implement appropriate measures to protect your information from unauthorized access, alteration, or destruction. However, no online platform is completely secure, and we cannot guarantee absolute security.



## 6. Your Rights
You have the right to:

- Access the personal data we hold about you.
- Correct or update inaccurate information.
- Request deletion of your account and personal data.

To exercise your rights, contact us at **[Insert Contact Information]**.



## 7. Changes to This Privacy Policy
We may update this Privacy Policy periodically. Changes will be posted in the app with the updated date.



## 8. Contact Us
If you have any questions about this Privacy Policy, please contact us at:

**Kudu Mart Support**  
Email: **[contact@kudumart.com]**  
Phone: **[+1 (345) 3211227]**



By using Kudu Mart, you agree to the terms of this Privacy Policy.

''';
}
