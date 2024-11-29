import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/constants.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final ItemScrollController _scrollController = ItemScrollController();
  int? _clickedQuestionIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          forceMaterialTransparency: true,
          leading: const AppBackButton(),
          title: const Text("FAQ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          titleSpacing: 0,
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 25,
              UiConstant.horizontalPadding, 10),
          child: Column(children: [
            const Text(
                "Here is a detailed Frequently Asked Questions (FAQ) section for Standard of Process or mode of services on the Kudu Mart platform:",
                style: TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            Flexible(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppUiColor.borderline)),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    padding: const EdgeInsets.all(0),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => _clickedQuestionIndex = index);

                          _scrollController.scrollTo(
                            index: index,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: Colors.orange,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                _questions[index],
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: _clickedQuestionIndex == index
                                        ? FontWeight.w700
                                        : FontWeight.w500),
                              ),
                            ))
                          ],
                        ),
                      );
                    },
                  ),
                )),
            const SizedBox(height: 20),
            Flexible(
              flex: 6,
              child: ScrollablePositionedList.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                padding: const EdgeInsets.all(0),
                itemScrollController: _scrollController,
                itemCount: _answers.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: _clickedQuestionIndex == index ? 6 : null,
                    color: _clickedQuestionIndex == index
                        ? AppUiColor.grey50
                        : Colors.white,
                    child: ListTile(
                      title: Text(_questions[index],
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: MarkdownBody(data: _answers[index]),
                    ),
                  );
                },
              ),
            )
          ]),
        ));
  }

  static const List<String> _questions = [
    "What is Kudu Mart?",
    "How can I become a vendor on Kudu Mart?",
    "Can a vendor create multiple stores?",
    "Do I need to register to view products?",
    "Why do I need to register to view a vendor's phone number?",
    "Is there a fee to display my products as a vendor?",
    "How do buyers contact vendors on Kudu Mart?",
    "What payment methods are supported for subscriptions?",
    "Can I cancel my vendor subscription?",
    "Are there any restrictions on the types of products vendors can sell?",
    "How can I report a vendor or product?",
  ];

  static const List<String> _answers = [
    "Kudu Mart is a platform that connects buyers and sellers. Vendors can register and display their products in virtual stores, while buyers can browse and purchase products.",
    "To become a vendor, you need to register as a user, then sign up for a vendor account through the app. Once registered, you can create your virtual stores and list products.",
    "Yes, as a vendor on Kudu Mart, you can create multiple virtual stores to organize and showcase your products effectively.",
    "No, you don’t need to register to view products on Kudu Mart. However, certain features, like viewing a vendor’s contact details, require registration.",
    "Registration ensures that buyer-seller interactions are secure and verified. It also helps us maintain a trusted community on the platform.",
    "Yes, vendors are required to pay a subscription fee to have their products displayed to potential buyers on Kudu Mart.",
    "Buyers can contact vendors by viewing their phone numbers, but only after registering on the platform.",
    "Kudu Mart supports various payment methods for vendor subscriptions, including credit/debit cards and mobile payment options.",
    "Yes, you can cancel your vendor subscription at any time. However, subscription fees are non-refundable, and your products will no longer be displayed to buyers.",
    "Yes, vendors are restricted from selling illegal, prohibited, or counterfeit goods. All products must comply with Kudu Mart's policies and local laws.",
    "If you encounter an issue with a vendor or product, you can report it through the app’s reporting feature, available in the product or vendor profile section.",
  ];
}
