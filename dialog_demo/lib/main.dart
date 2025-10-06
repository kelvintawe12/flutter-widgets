import 'package:flutter/material.dart';

void main() {
  runApp(const DialogDemoApp());
}

class DialogDemoApp extends StatelessWidget {
  const DialogDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dialog Demo',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const DialogHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DialogHomePage extends StatefulWidget {
  const DialogHomePage({super.key});

  @override
  State<DialogHomePage> createState() => _DialogHomePageState();
}

class _DialogHomePageState extends State<DialogHomePage> {
  bool barrierDismissible = true;

  final List<_ShapeOption> shapeOptions = [
    _ShapeOption('Rectangle', null),
    _ShapeOption('Rounded 12', RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    _ShapeOption('Rounded 24', RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
    _ShapeOption('Stadium', StadiumBorder()),
  ];

  int selectedShapeIndex = 1;

  final List<_ColorOption> colorOptions = [
    _ColorOption('Default', null),
    _ColorOption('Light Blue', Colors.blue.shade50),
    _ColorOption('Soft Red', Colors.red.shade50),
    _ColorOption('Cream', Color(0xFFFFF8E1)),
  ];

  int selectedColorIndex = 0;

  String lastResult = 'No dialog shown yet';

  @override
  Widget build(BuildContext context) {
    final shapeName = shapeOptions[selectedShapeIndex].name;
    final colorName = colorOptions[selectedColorIndex].name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog Widgets — Demo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Pick three dialog settings below and press "Show Dialog" to see the result.\nThe dialog will return a value you can see in the status area.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Barrier dismissible toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Allow tap outside to dismiss', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: barrierDismissible,
                    onChanged: (v) => setState(() => barrierDismissible = v),
                  )
                ],
              ),

              const SizedBox(height: 12),

              // Shape selector
              Row(
                children: [
                  const Text('Shape:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedShapeIndex,
                      items: List.generate(shapeOptions.length, (i) => DropdownMenuItem(value: i, child: Text(shapeOptions[i].name))),
                      onChanged: (i) => setState(() => selectedShapeIndex = i ?? 0),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Background color selector
              Row(
                children: [
                  const Text('Background color:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedColorIndex,
                      items: List.generate(colorOptions.length, (i) => DropdownMenuItem(value: i, child: Text(colorOptions[i].name))),
                      onChanged: (i) => setState(() => selectedColorIndex = i ?? 0),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Show Dialog'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
                  onPressed: _showConfiguredDialog,
                ),
              ),

              const SizedBox(height: 20),

              const Divider(),

              const SizedBox(height: 8),

              Text('Current settings: Shape = $shapeName, Color = $colorName, tapOutsideDismiss = $barrierDismissible'),

              const SizedBox(height: 12),

              Text('Dialog result: $lastResult', style: const TextStyle(fontWeight: FontWeight.bold)),

              const Spacer(),

              const Text('Tip: During demo mention these three properties:'),
              const SizedBox(height: 6),
              const Text('- barrierDismissible (on showDialog): prevents or allows outside tap to dismiss.', style: TextStyle(fontSize: 12)),
              const Text('- shape (on AlertDialog): controls corner radius and border.', style: TextStyle(fontSize: 12)),
              const Text('- backgroundColor (on AlertDialog): changes the dialog surface color.', style: TextStyle(fontSize: 12)),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showConfiguredDialog() async {
    final chosenShape = shapeOptions[selectedShapeIndex].shape;
    final chosenColor = colorOptions[selectedColorIndex].color;

    // showDialog returns a Future<T?> which completes when Navigator.pop is called inside the dialog.
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dialog barrier',
      builder: (ctx) {
        return AlertDialog(
          semanticLabel: 'Demo Alert Dialog',
          shape: chosenShape,
          backgroundColor: chosenColor,
          title: Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.indigo),
              SizedBox(width: 8),
              Expanded(child: Text('Confirm action')),
            ],
          ),
          content: const Text('This dialog demonstrates barrierDismissible, shape, and backgroundColor. Choose an action or dismiss (if allowed).'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('cancelled'),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop('confirmed'),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    setState(() {
      if (result == null) {
        lastResult = 'Dismissed (null)';
      } else {
        lastResult = result;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dialog result: $lastResult')));
  }
}

class _ShapeOption {
  final String name;
  final ShapeBorder? shape;
  _ShapeOption(this.name, this.shape);
}

class _ColorOption {
  final String name;
  final Color? color;
  _ColorOption(this.name, this.color);
}
