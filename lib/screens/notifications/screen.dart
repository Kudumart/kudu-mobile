import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/shared_widgets/divider.dart';
import 'package:kudu/core/shared_widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../models/home/notifications_model.dart';
import '../../models/notification.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../providers/home_provider.dart';

part 'widgets/notification_data_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool loading = false;
  List<NotificationDataFromApi> notifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNotifications();
    });
  }

  Future<void> fetchNotifications() async {
    if(mounted){
      setState(() {
        loading = true;
      });
    }
    var response = await Provider.of<HomeViewModel>(context, listen: false).fetchNotifications();
    notifications = response?.data ?? [];
    if(mounted){
      setState(() {
        loading = false;
      });
    }
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
            // IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       CupertinoIcons.ellipsis_vertical,
            //     ))
          ],
        ),
        body: Builder(
          builder: (context) {
            if (loading) {
              return const AppLoadingIndicator();
            }
            return Padding(
              padding: const EdgeInsets.only(left: UiConstant.horizontalPadding,right: UiConstant.horizontalPadding),
              child: ListView.separated(
                itemBuilder: (_, index) => _NotificationDataCard(NotificationData(
                  id: notifications[index].id ?? "",
                  content: notifications[index].message ?? "No Content",
                  title: notifications[index].title ?? "No Title",
                  created: DateTime.tryParse(notifications[index].createdAt ?? "") ?? DateTime.now(),
                  isRead: true,
                )),
                separatorBuilder: (_, __) =>
                const CustomDivider(withoutMargin: true),
                itemCount: notifications.length,
              ),
            );
          }
        ));
  }
}
