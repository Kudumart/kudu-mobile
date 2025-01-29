part of 'controller.dart';

class _DateChip extends StatelessWidget {
  final DateTime date;
  final Color color;
  const _DateChip({
    Key? key,
    required this.date,
    this.color = const Color(0x558AD3D5),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 22),
        padding: const EdgeInsets.only(
          top: 7,
          bottom: 7,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            formatDate(date, [dd, " ", MM, " ", yyyy]),
          ),
        ),
      ),
    );
  }
}
