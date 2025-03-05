part of '../../../screen.dart';

class _SpecsAndBidPrice extends StatelessWidget {
  final Map<String, dynamic> specification;
  final String bidPrice;
  const _SpecsAndBidPrice(
      {required this.specification, required this.bidPrice});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...specification.keys.map((key) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(key),
                const SizedBox(height: 3),
                _Value(specification[key]),
                const SizedBox(height: 13),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String value;
  const _Title(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
          fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
    );
  }
}

class _Value extends StatelessWidget {
  final String value;
  const _Value(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
          fontSize: 13, color: Color(0xFF5F5F5F), fontWeight: FontWeight.w400),
    );
  }
}
