import 'package:flutter/widgets.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:url_launcher/url_launcher.dart';

callNumber(BuildContext context, String phoneNumber) async {
  final uri = Uri(scheme: "tel", path: phoneNumber);
  if (await canLaunchUrl(uri)) {
    launchUrl(uri);
  } else {
    AppUiOverlay().showErrorSnackbarMessage(context, message: "Can not call phone number $phoneNumber");
  }
  
}