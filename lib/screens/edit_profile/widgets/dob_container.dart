part of '../screen.dart';

class _DoBView extends StatefulWidget {
  final String? date;
  final Function(String)? onDateSelected;

  const _DoBView(this.date, {this.onDateSelected});

  @override
  State<_DoBView> createState() => _DoBViewState();
}

class _DoBViewState extends State<_DoBView> {
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.date;
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Date of Birth";

    try {
      final DateTime parsedDate = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppUiColor.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked.toIso8601String();
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(selectedDate!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: Container(
        height: 48,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDate(selectedDate),
              style: const TextStyle(
                fontSize: 13,
                color: AppUiColor.primary,
              ),
            ),
            const Icon(
              CupertinoIcons.calendar,
              color: Colors.black,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
