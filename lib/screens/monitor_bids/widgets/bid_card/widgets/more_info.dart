part of '../../../screen.dart';

class _MoreInfo extends StatelessWidget {
  final String bidPrice;
  final AuctionStatus status;
  final String timeLeft;
  const _MoreInfo(
      {required this.status, required this.timeLeft, required this.bidPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Title("Status"),
        const SizedBox(height: 3),
        _Value(
          status.printableName(),
          textColor: _statusColor(),
        ),
        const SizedBox(height: 13),
        const _Title("Time Left"),
        const SizedBox(height: 3),
        _Value(
          timeLeft,
          textColor: AppUiColor.primary,
        ),
        const SizedBox(height: 13),
        const _Title("Current Bid:"),
        const SizedBox(height: 3),
        _Value(bidPrice),
      ],
    );
  }

  Color _statusColor() {
    switch (status) {
      case AuctionStatus.ongoing:
        return Colors.green;
      case AuctionStatus.upcoming:
        return const Color.fromARGB(255, 255, 156, 34);
      case AuctionStatus.closed:
        return AppUiColor.iconBlack;
      default:
        return Colors.black;
    }
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
  final Color? textColor;
  const _Value(this.value, {this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
          fontSize: 13,
          color: textColor ?? const Color(0xFF5F5F5F),
          fontWeight: FontWeight.w400),
    );
  }
}
