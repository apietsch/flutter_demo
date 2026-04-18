## 1. Remove swipe demo entry points

- [x] 1.1 Remove the swipe demo action and related imports from the lorem loader screen.
- [x] 1.2 Search the app for active `SwipeDemoPage` references and remove any remaining navigation wiring.

## 2. Clean up retired swipe demo code

- [x] 2.1 Delete the swipe demo feature files if they are no longer referenced anywhere in the app.
- [x] 2.2 Update or remove tests and other references that still depend on the swipe demo.

## 3. Validate remaining demo flows

- [x] 3.1 Run `flutter analyze` and fix any issues introduced by the cleanup.
- [x] 3.2 Run relevant tests and verify the lorem loader and screening workspace entry points still work as expected.
