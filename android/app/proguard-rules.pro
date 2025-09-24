# Flutter y Dart
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Audio players
-keep class xyz.luan.audioplayers.** { *; }

# HTTP y networking
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# Syncfusion charts
-keep class com.syncfusion.** { *; }

# Math expressions
-keep class math_expressions.** { *; }

# General Android optimizations for calculators
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Prevent obfuscation of math operations
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Google Play Core (soluciona error R8)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**