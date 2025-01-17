import 'package:flutter/material.dart';

class DurationPickerDialog extends StatefulWidget {
  final Duration initialDuration;
  final Duration maxDuration;

  const DurationPickerDialog(
      {super.key, required this.initialDuration, required this.maxDuration});

  @override
  // ignore: library_private_types_in_public_api
  _DurationPickerDialogState createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late Duration selectedDuration;

  @override
  void initState() {
    super.initState();
    selectedDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Set Timer"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              "Set the timer duration (Max: ${widget.maxDuration.inHours} hours)"),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<int>(
                value: selectedDuration.inHours,
                items: List.generate(
                        widget.maxDuration.inHours + 1, (index) => index)
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDuration = Duration(
                        hours: value!,
                        minutes: selectedDuration.inMinutes % 60);
                  });
                },
              ),
              const Text(" h "),
              DropdownButton<int>(
                value: selectedDuration.inMinutes % 60,
                items: List.generate(60, (index) => index)
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDuration = Duration(
                        hours: selectedDuration.inHours, minutes: value!);
                  });
                },
              ),
              const Text(" m "),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedDuration);
          },
          child: const Text("Set"),
        ),
      ],
    );
  }
}
