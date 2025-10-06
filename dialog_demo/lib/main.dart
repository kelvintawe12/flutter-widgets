import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Main entry point of the application.
void main() {
  runApp(const DialogDemoApp());
}

// The root widget of the app, configured with a Material theme.
class DialogDemoApp extends StatelessWidget {
  const DialogDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dialog Examples',
      debugShowCheckedModeBanner: false,
      // Enhanced theme with a modern color scheme, font, and elevations for better UI.
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        useMaterial3: true, // Enables Material 3 for smoother designs.
      ),
      home: const DialogHomePage(),
    );
  }
}

// The home page, now stateful to handle dialog results and display feedback (e.g., via Snackbar).
// This adds robustness by processing user selections and providing visual confirmation.
class DialogHomePage extends StatefulWidget {
  const DialogHomePage({super.key});

  @override
  State<DialogHomePage> createState() => _DialogHomePageState();
}

class _DialogHomePageState extends State<DialogHomePage> {
  String? _lastSelectedValue; // Stores the last selected value for display or further use.
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0; // 0 = transparent, 1 = opaque

  // --- SIMPLE DIALOG ---
  // Shows a simple dialog with language options. Enhanced with rounded corners, padding,
  // and icons for better UI. Now async to handle the result robustly.
  Future<void> _showSimpleDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside.
      barrierColor: Colors.black.withOpacity(0.3), // Subtle overlay for focus.
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Language'),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8, // Adds shadow for depth.
          children: [
            _buildAnimatedDialogOption(
              icon: Icons.language,
              text: 'English',
              onPressed: () => Navigator.pop(context, 'English'),
            ),
            _buildAnimatedDialogOption(
              icon: Icons.language,
              text: 'French',
              onPressed: () => Navigator.pop(context, 'French'),
            ),
            _buildAnimatedDialogOption(
              icon: Icons.language,
              text: 'Kinyarwanda',
              onPressed: () => Navigator.pop(context, 'Kinyarwanda'),
            ),
          ],
        );
      },
    );

    // Handle the result: Update state and show a Snackbar for user feedback.
    if (result != null && context.mounted) {
      setState(() => _lastSelectedValue = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected: $result'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // --- ALERT DIALOG ---
  // Shows an alert dialog for confirmation. Enhanced with icons, custom colors,
  // and non-dismissible barrier for critical actions.
  Future<void> _showAlertDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal.
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item? This action cannot be undone.'),
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Delete'),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (result != null && context.mounted) {
      setState(() => _lastSelectedValue = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action: $result'),
          backgroundColor: result == 'Delete' ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // --- CUPERTINO ALERT DIALOG ---
  // iOS-style dialog. Enhanced with more content and custom actions.
  Future<void> _showCupertinoDialog(BuildContext context) async {
    final result = await showCupertinoDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('iOS Style Dialog'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('This is a Cupertino-style alert dialog with enhanced details.'),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK', style: TextStyle(color: CupertinoColors.activeBlue)),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (result != null && context.mounted) {
      setState(() => _lastSelectedValue = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Response: $result'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // --- BOTTOM SHEET ---
  // Modal bottom sheet with options. Enhanced with rounded corners, drag handle,
  // and staggered animations for list items.
  Future<void> _showBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // Allows full control for taller sheets.
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300, // Increased height for more content.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle for better UX.
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'Choose an Option',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    _buildAnimatedListTile(
                      icon: Icons.share,
                      title: 'Share',
                      onTap: () => Navigator.pop(context, 'Share'),
                      delay: 100,
                    ),
                    _buildAnimatedListTile(
                      icon: Icons.edit,
                      title: 'Edit',
                      onTap: () => Navigator.pop(context, 'Edit'),
                      delay: 200,
                    ),
                    _buildAnimatedListTile(
                      icon: Icons.delete,
                      title: 'Delete',
                      onTap: () => Navigator.pop(context, 'Delete'),
                      delay: 300,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      setState(() => _lastSelectedValue = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Option: $result'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Helper widget for animated dialog options with fade-in animation.
  Widget _buildAnimatedDialogOption({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: SimpleDialogOption(
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, color: Colors.indigo),
            const SizedBox(width: 16),
            Text(text),
          ],
        ),
      ),
    );
  }

  // Helper widget for animated list tiles in bottom sheet with slide-in animation.
  Widget _buildAnimatedListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required int delay,
  }) {
    return AnimatedSlide(
      offset: const Offset(0, 0), // Starts from bottom, slides up.
      duration: Duration(milliseconds: 300 + delay),
      curve: Curves.easeOut,
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  // --- MAIN UI ---
  // Enhanced home page UI with gradient background, card for buttons, and last selection display.
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // Fade in the app bar background as user scrolls down.
      final offset = _scrollController.offset;
      final target = (offset / 160).clamp(0.0, 1.0);
      if ((target - _appBarOpacity).abs() > 0.01) {
        setState(() => _appBarOpacity = target);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom animated app bar: background fades in on scroll and casts a shadow.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_appBarOpacity * 0.95),
            boxShadow: _appBarOpacity > 0.05
                ? [BoxShadow(color: Colors.black.withOpacity(0.12 * _appBarOpacity), blurRadius: 8, offset: const Offset(0, 2))]
                : [],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.indigo.shade200,
                      child: const Icon(Icons.question_mark, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        // Interpolate font size between 20 and 18 based on opacity.
                        fontSize: 20 - 2 * _appBarOpacity,
                        fontWeight: FontWeight.w600,
                        color: _appBarOpacity > 0.5 ? Colors.black87 : Colors.indigo.shade900,
                      ),
                      child: const Text('Modal Dialogs in Flutter', textAlign: TextAlign.center),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Quick demo',
                    icon: const Icon(Icons.play_circle_fill),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Quick Demo'),
                          content: const Text('Tap the buttons on the card to explore different dialog types.'),
                          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: 'About',
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Dialog Demo',
                        applicationVersion: '0.1.0',
                        children: [const Text('A demo of Flutter dialogs: AlertDialog, SimpleDialog, CupertinoAlertDialog, and bottom sheets.')],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true, // Allows gradient to show under app bar.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo[100]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            // Use LayoutBuilder + SingleChildScrollView so the content centers on tall
            // screens but becomes scrollable on small screens to avoid RenderFlex overflow.
            child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Tap a button below to explore different types of dialogs with animations and feedback:',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          if (_lastSelectedValue != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Last Selection: $_lastSelectedValue',
                              style: const TextStyle(fontSize: 16, color: Colors.indigo, fontStyle: FontStyle.italic),
                            ),
                          ],
                          const SizedBox(height: 32),
                          // Wrap buttons in a Card for grouped, elevated UI. Constrain width on
                          // large screens so the card doesn't stretch too wide.
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 640),
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      _buildAnimatedButton(
                                        onPressed: () => _showSimpleDialog(context),
                                        child: const Text('Show Simple Dialog'),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildAnimatedButton(
                                        onPressed: () => _showAlertDialog(context),
                                        child: const Text('Show Alert Dialog'),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildAnimatedButton(
                                        onPressed: () => _showCupertinoDialog(context),
                                        child: const Text('Show Cupertino Dialog'),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildAnimatedButton(
                                        onPressed: () => _showBottomSheet(context),
                                        child: const Text('Show Bottom Sheet'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Quick Tip'),
              content: const Text('Use barrierDismissible to control whether tapping outside closes a dialog.'),
              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Got it'))],
            ),
          );
        },
        label: const Text('Tip'),
        icon: const Icon(Icons.lightbulb),
      ),
    );
  }

  // Helper for animated buttons with scale animation on press.
  Widget _buildAnimatedButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}