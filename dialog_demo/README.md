# Dialog Demo

A small, polished Flutter demo app that showcases Dialog widgets and three visual properties: `barrierDismissible`, `shape`, and `backgroundColor`.

One-line widget description

- Dialog widgets: transient modal routes used to alert users or request decisions. This demo focuses on `AlertDialog` and `showDialog`.

Run instructions

1. Open a terminal in the `dialog_demo` folder.
2. Run:

```bash
flutter pub get
flutter run
```

What to demo (three properties)

1. barrierDismissible (on `showDialog`) — when false, tapping outside or pressing back will not dismiss the dialog; when true it will.
2. shape (on `AlertDialog`) — controls the dialog border and corner radius (e.g., rounded corners, stadium border).
3. backgroundColor (on `AlertDialog`) — changes the surface color of the dialog to match branding or indicate importance.

Notes

- The app returns a `String` result from the dialog: `'confirmed'`, `'cancelled'`, or null if dismissed.
- During your 3-5 minute presentation: (1) run the demo, (2) walk through the `showDialog` call and the `AlertDialog` builder, (3) toggle each property and show the visual change.

Screenshot

_Replace this with a screenshot after you run the app._
