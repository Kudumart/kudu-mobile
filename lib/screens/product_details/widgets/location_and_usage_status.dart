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
        Expanded(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF5F5F5F)),
          ),
        ),
        const SizedBox(width: 8),
        Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: condition == ProductCondition.brandNew
                    ? const Color(0xFF34A853)
                    : const Color(0xFFFF0F00)),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                condition == ProductCondition.brandNew ? "Brand New" : "Used",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            )),
        if(trailingWidget != null) ...[
          const SizedBox(width: 6),
          trailingWidget!,
        ],
      ],
    );
  }
}
