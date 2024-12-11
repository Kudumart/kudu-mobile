import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../constants.dart';
import '../../shared_widgets/back_button.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 0,
        title: const Text(
          "Terms and Conditions",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        leading: const AppBackButton(),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
            horizontal: UiConstant.horizontalPadding, vertical: 20),
        child: Markdown(data: _content),
      ),
    );
  }

  static const String _content = '''
## 1. Terms of Service
By using Kudu, users agree to the following:
- Buyers and vendors must provide accurate and complete information during registration.
- Any misuse of the platform, including fraudulent activity, will result in immediate suspension or termination of the account.
- Kudu is not liable for disputes arising from transactions between buyers and vendors but will mediate in compliance with our dispute resolution process.
  
  
## 2. Refund and Return Policy
- Buyers can request a refund or return within [specific timeframe, e.g., 7–14 days] of receiving a product.
- Vendors are responsible for processing approved returns and refunds promptly.
- Refund eligibility is subject to product condition and reason for return, as outlined in our Return Policy Guide.

## 3. Vendor Policy
Vendors are expected to:
- List only authentic, high-quality products.
- Clearly state product details, pricing, and shipping information.
- Handle buyer inquiries, disputes, and returns professionally.

Failure to adhere to these standards may result in account suspension.

## 4. Shipping Policy
- Vendors must provide accurate shipping timelines and tracking information.
- Buyers should report any delays or issues promptly for resolution.
- Kudu supports international shipping, but customs and additional fees are the buyer's responsibility.

## 5. Payment Policy
- All transactions are processed securely through Kudu's payment gateway.
- Payments to vendors are released after product delivery confirmation.
- Refunds are processed directly through the payment method used during purchase.

## 6. Prohibited Items Policy
The following are not allowed on Kudu:
- Counterfeit or illegal goods.
- Hazardous materials or substances.
- Any items violating local, national, or international laws.

## 7. Community and Communication Policy
- Users must engage respectfully with others on the platform.
- Harassment, spam, or inappropriate behavior will result in account termination.

## 8. Dispute Resolution Policy
- Disputes between buyers and vendors must be reported to Kudu within [specific timeframe, e.g., 48–72 hours].
- Kudu will investigate and mediate disputes to ensure a fair outcome.

## 9. Updates to Policies
- Kudu reserves the right to update these policies at any time.
- Users will be notified of significant changes and are encouraged to review policies periodically.

''';
}
