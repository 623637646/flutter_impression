# flutter_impression
This is a user behavior tracking (UBT) tool to analyze impression events for flutter. Inspired by [ImpressionKit](https://github.com/623637646/ImpressionKit) and [visibility_detector](https://github.com/google/flutter.widgets/tree/master/packages/visibility_detector)

https://user-images.githubusercontent.com/5275802/187019180-c877edfa-a3d6-4a0d-9c78-7da4febd9ce8.mov

# How to use

```dart

ImpressionDetector(
  impressedCallback: () {
    debugPrint('impressed');
  },
  child: MyWidget(),
)

```

Refer to the Demo for more details.

# How to integrate

Add dependency

```yaml
dependencies:
  impression: ^latest version
```
