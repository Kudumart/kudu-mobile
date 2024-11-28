part of '../screen.dart';

class _AuctionStep extends StatelessWidget {
  final int number;
  final String name;
  final String explanation;
  const _AuctionStep(
      {required this.number, required this.name, required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 18),
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(18.6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32.5,
                width: 32.5,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: AppUiColor.primary, shape: BoxShape.circle),
                child: Text(
                  "$number",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              Text(name,
                  style: const TextStyle(
                      fontSize: 16.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 13.08),
          Expanded(
            child: Text(explanation,
                style: const TextStyle(
                    fontSize: 13.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
