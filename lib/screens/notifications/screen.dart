import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/shared_widgets/divider.dart';
import 'package:kudu/core/shared_widgets/loading_indicator.dart';

import '../../models/notification.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';

part 'widgets/notification_data_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final Future<List<NotificationData>> _fetchNotifications;
  @override
  void initState() {
    super.initState();
    _fetchNotifications = _fetchUserNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("Notifications",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          forceMaterialTransparency: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                ))
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 5,
              UiConstant.horizontalPadding, 10),
          child: FutureBuilder<List<NotificationData>>(
              future: _fetchNotifications,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AppLoadingIndicator();
                }

                if (snapshot.hasError) {
                  final String error = snapshot.error!.toString();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppUiImage.shoppingBag),
                      const SizedBox(height: 22),
                      const Text(
                        "Error",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppUiColor.iconBlack,
                        ),
                      ),
                    ],
                  );
                }

                final notifications = snapshot.data as List<NotificationData>;
                return ListView.separated(
                    itemBuilder: (_, index) =>
                        _NotificationDataCard(notifications[index]),
                    separatorBuilder: (_, __) =>
                        const CustomDivider(withoutMargin: true),
                    itemCount: notifications.length);
              }),
        ));
  }

  Future<List<NotificationData>> _fetchUserNotifications() async {
    Future.delayed(const Duration(seconds: 2));
    return List.filled(
        12,
        NotificationData(
            content:
                "Withdrawal of ₦13,000 carried out from your wallet is successful.",
            id: "1",
            created: DateTime.now(),
            title: "Stripe Payment Successful",
            isRead: false));
  }
}
