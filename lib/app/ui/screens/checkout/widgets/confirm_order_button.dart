part of '../screen.dart';

class _ConfirmOrderButton extends StatelessWidget {
  const _ConfirmOrderButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            offset: const Offset(0, -4),
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: ElevatedButton(
          style: ButtonStyle(
              fixedSize:
                  const WidgetStatePropertyAll(Size(double.infinity, 47)),
              shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)))),
          onPressed: () {},
          child: const Text("Confirm Order")),
    );
  }
}
