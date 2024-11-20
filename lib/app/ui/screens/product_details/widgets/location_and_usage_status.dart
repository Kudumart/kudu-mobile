part of '../screen.dart';

class _LocationAndUsageStatusView extends StatelessWidget {
  final String location;
  final UsageStatus usageStatus;
  const _LocationAndUsageStatusView(
      {required this.location, required this.usageStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AppUiIcon.location,
            height: 18, width: 18, fit: BoxFit.contain),
        const SizedBox(width: 5),
        Text(
          location,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF5F5F5F)),
        ),
        const Expanded(child: SizedBox()),
        Container(
            height: 30,
            width: 83,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: usageStatus == UsageStatus.brandNew
                    ? const Color(0xFF34A853)
                    : const Color(0xFFFF0F00)),
            child: Text(
              usageStatus == UsageStatus.brandNew ? "Brand New" : "Used",
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ))
      ],
    );
  }
}
