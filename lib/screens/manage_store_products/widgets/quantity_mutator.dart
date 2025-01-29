part of '../screen.dart';

class _QuantityMutator extends StatefulWidget {
  const _QuantityMutator();

  @override
  _QuantityMutatorState createState() => _QuantityMutatorState();
}

class _QuantityMutatorState extends State<_QuantityMutator> {
  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      width: 85,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Decrement Button
          GestureDetector(
            onTap: _decrement,
            child: Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: AppUiColor.borderline),
                  borderRadius: BorderRadius.circular(5)),
              child: const Icon(
                Icons.remove,
                size: 18,
              ),
            ),
          ),

          // Quantity Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$_quantity',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Increment Button
          GestureDetector(
            onTap: _increment,
            child: Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: AppUiColor.borderline),
                  borderRadius: BorderRadius.circular(5)),
              child: const Icon(
                Icons.add,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
