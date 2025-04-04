part of '../screen.dart';

class _LocationAndProductConditionView extends StatelessWidget {
  final String location;
  final ProductCondition condition;
  final Widget? trailingWidget;
  const _LocationAndProductConditionView({required this.location, required this.condition, this.trailingWidget});

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
                color: condition == ProductCondition.brandNew
                    ? const Color(0xFF34A853)
                    : const Color(0xFFFF0F00)),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  condition == ProductCondition.brandNew ? "Brand New" : "Used",
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            )),
        if(trailingWidget != null) ...[
          const SizedBox(width: 10),
          trailingWidget!,
        ],
      ],
    );
  }
}
