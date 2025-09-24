import 'package:flutter/material.dart';
// flutter_svg removed to improve performance; rendering will fallback to
// native text placeholders instead of parsing SVG at runtime.
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Widget unificado para botones basados en assets (SVG/PNG) o texto.
class AssetButton extends StatelessWidget {
  final String text;
  final String?
      asset; // ruta relativa en assets, ej: 'assets/icons/buttons/btn_7.svg'
  final String? secondary;
  final VoidCallback? onPressed;
  final void Function()? onLongPress;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isWide;
  final double height;
  final double? fontSize;
  final bool circular;
  final double iconSize;
  final bool skipSanitization;
  // If true, draw a subtle contrasting background behind the asset for debugging
  final bool debugBg;

  const AssetButton({
    super.key,
    required this.text,
    this.asset,
    this.secondary,
    this.skipSanitization = false,
    this.debugBg = false,
    this.onPressed,
    this.onLongPress,
    this.backgroundColor,
    this.textColor,
    this.isWide = false,
    this.fontSize,
    this.height = 56,
    this.circular = false,
    this.iconSize = 18,
  });

  // Simple in-memory cache for sanitized SVG strings keyed by asset path.
  static final Map<String, String> _sanitizedCache = {};

  /// Clear the sanitized SVG cache (useful for development or when assets
  /// are replaced at runtime).
  static void clearSanitizedCache() {
    _sanitizedCache.clear();
  }

  /// Returns number of cached sanitized SVG entries.
  static int get sanitizedCacheSize => _sanitizedCache.length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surface;
    final fg = textColor ?? theme.colorScheme.onSurface;

    Color _alpha(Color c, double f) {
      final a = (f * 255).round().clamp(0, 255);
      final r = ((c.r * 255).round()) & 0xFF;
      final g = ((c.g * 255).round()) & 0xFF;
      final b = ((c.b * 255).round()) & 0xFF;
      return Color.fromARGB(a, r, g, b);
    }

    Widget content() {
      // If an asset is provided, attempt to load a sanitized variant off-thread
      // but render a lightweight text placeholder to avoid SVG parsing cost.
      if (asset != null) {
        if (skipSanitization) {
          return Center(child: _textColumn(fg));
        }

        return FutureBuilder<String?>(
          future: () async {
            final cached = _sanitizedCache[asset!];
            if (cached != null) return cached;
            final bundle = DefaultAssetBundle.of(context);
            final sanitized =
                await AssetButton.loadAndSanitizeAssetOffThread(bundle, asset!);
            if (sanitized != null) _sanitizedCache[asset!] = sanitized;
            return sanitized;
          }(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              try {
                // Instead of rendering the sanitized SVG, show a compact
                // text placeholder to keep runtime cost minimal.
                return Center(
                  child: Container(
                    width: iconSize + 8,
                    height: iconSize + 8,
                    alignment: Alignment.center,
                    decoration: backgroundColor != null
                        ? BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(6),
                          )
                        : null,
                    child: _textColumn(textColor ?? fg),
                  ),
                );
              } catch (_) {
                return _textColumn(fg);
              }
            }
            // while loading or if not found show a compact placeholder (text)
            return _textColumn(fg);
          },
        );
      }

      return _textColumn(fg);
    }

    if (circular) {
      // If an SVG asset is provided, show the image itself as the tappable
      // control (no extra circular background). Otherwise keep the original
      // circular decorated button behavior.
      if (asset != null) {
        return Container(
          height: height,
          margin: const EdgeInsets.all(4),
          decoration: debugBg
              ? BoxDecoration(
                  color: _alpha(Colors.black, 0.06),
                  borderRadius: BorderRadius.circular(999),
                )
              : null,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onPressed,
              onLongPress: onLongPress,
              borderRadius: BorderRadius.circular(999),
              child: Center(child: content()),
            ),
          ),
        );
      }

      return Container(
        height: height,
        margin: const EdgeInsets.all(4),
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(999),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: content(),
            ),
          ),
        ),
      );
    }

    // When an asset is provided we want the image itself to be the button
    // (not an ElevatedButton with the image inside). Use an InkWell over a
    // transparent Material so ripples work; preserve the optional secondary
    // label beneath the image.
    if (asset != null) {
      return Container(
        height: height,
        margin: const EdgeInsets.all(4),
        decoration: debugBg
            ? BoxDecoration(
                color: _alpha(Colors.black, 0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color.fromARGB(0x12, 0, 0, 0)),
              )
            : null,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: content()),
                if (secondary != null && secondary!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      secondary!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Color.fromARGB(
                            (0.75 * 255).round(),
                            (fg.r * 255).round(),
                            (fg.g * 255).round(),
                            (fg.b * 255).round()),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: height,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: content()),
            if (secondary != null && secondary!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  secondary!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color.fromARGB(
                        (0.75 * 255).round(),
                        (fg.r * 255).round(),
                        (fg.g * 255).round(),
                        (fg.b * 255).round()),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _textColumn(Color fg) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  // Basic sanitizer to remove common Corel/INkscape constructs that flutter_svg rejects
  String _sanitizeSvgString(String raw) {
    var s = raw;
    s = s.replaceAll(RegExp(r'<\?xml[\s\S]*?\?>', caseSensitive: false), '');
    s = s.replaceAll(RegExp(r'<!DOCTYPE[\s\S]*?>', caseSensitive: false), '');
    s = s.replaceAll(
        RegExp(r'<style[\s\S]*?<\/style>', caseSensitive: false), '');
    s = s.replaceAll(
        RegExp(r'<metadata[\s\S]*?<\/metadata>', caseSensitive: false), '');
    s = s.replaceAll(
        RegExp(r'<font[\s\S]*?<\/font>', caseSensitive: false), '');
    s = s.replaceAll(
        RegExp(r'<defs[\s\S]*?<\/defs>', caseSensitive: false), '');
    // remove style attributes (inline) to avoid css rules overriding colors
    s = s.replaceAll(RegExp(r'style="[^"]*"', caseSensitive: false), '');
    // normalize common fill/stroke usages to use currentColor so SvgPicture.color works
    s = s.replaceAllMapped(
        RegExp(r'fill\s*=\s*"#?([0-9a-fA-F]{3,8}|[a-zA-Z]+)"'),
        (m) => 'fill="currentColor"');
    s = s.replaceAllMapped(
        RegExp(r'stroke\s*=\s*"#?([0-9a-fA-F]{3,8}|[a-zA-Z]+)"'),
        (m) => 'stroke="currentColor"');
    // also replace style=...fill:... and style=...stroke:...
    s = s.replaceAllMapped(
        RegExp(r'fill:\s*#?[0-9a-fA-F]{3,8}'), (m) => 'fill:currentColor');
    s = s.replaceAllMapped(
        RegExp(r'stroke:\s*#?[0-9a-fA-F]{3,8}'), (m) => 'stroke:currentColor');
    s = s.replaceAllMapped(
        RegExp(r'(width|height)="(\d+(?:\.\d+)?)mm"', caseSensitive: false),
        (m) => '${m[1]}="${(double.parse(m[2]!).round()).toString()}px"');
    s = s.replaceAll(RegExp(r'xml:[a-zA-Z0-9_-]+="[^"]*"'), '');
    // Remove explicit width/height so SvgPicture can size using viewBox + provided
    // width/height parameters (prevents very small intrinsic sizes like "8px").
    s = s.replaceAll(
        RegExp(r'\s+(width|height)\s*=\s*"[^"]+"', caseSensitive: false), '');
    s = s.replaceAll(RegExp(r'\s+'), ' ');

    // If the SVG has a very large viewBox (typical of some Corel/Illustrator
    // exports) normalize it by wrapping the inner content in a <g> that
    // translates and scales the coordinates to fit a 512x512 viewport. This
    // preserves the graphic while making it renderable and reasonably sized
    // by flutter_svg.
    try {
      final vbMatch = RegExp(r'viewBox\s*=\s*"([^"]+)"', caseSensitive: false)
          .firstMatch(s);
      if (vbMatch != null) {
        final parts = vbMatch
            .group(1)!
            .split(RegExp(r'[ ,]+'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (parts.length == 4) {
          final minX = double.tryParse(parts[0]) ?? 0.0;
          final minY = double.tryParse(parts[1]) ?? 0.0;
          final vbW = double.tryParse(parts[2]) ?? 0.0;
          final vbH = double.tryParse(parts[3]) ?? 0.0;
          final maxDim = vbW > vbH ? vbW : vbH;
          // Only apply heuristic for unusually large viewBoxes
          if (maxDim > 1024.0) {
            final scale = (512.0 / maxDim);
            final scaleStr = scale.toStringAsFixed(6);
            final tx = (-minX).toStringAsFixed(2);
            final ty = (-minY).toStringAsFixed(2);

            // Replace viewBox with normalized 0 0 512 512
            s = s.replaceFirstMapped(
                RegExp(r'<svg([^>]*)viewBox\s*=\s*"[^"]+"([^>]*)>',
                    caseSensitive: false), (m) {
              final before = m.group(1) ?? '';
              final after = m.group(2) ?? '';
              return '<svg${before}viewBox="0 0 512 512"${after}>';
            });

            // Inject a wrapping group right after the opening <svg...> tag and
            // close it before </svg>
            s = s.replaceFirstMapped(
                RegExp(r'<svg[^>]*>', caseSensitive: false), (m) {
              // include fill/stroke defaults so shapes without explicit fills
              // inherit the widget color (currentColor)
              return '${m.group(0)}<g transform="translate($tx $ty) scale($scaleStr)" fill="currentColor" stroke="currentColor">';
            });
            // close group before final </svg>
            s = s.replaceFirstMapped(
                RegExp(r'</svg>\s* *$', caseSensitive: false),
                (m) => '</g></svg>');
            // If the above regex for closing didn't work (some files may have trailing data),
            // do a simple replace of the last occurrence of </svg>
            if (!s.contains('</g></svg>')) {
              final last = s.lastIndexOf('</svg>');
              if (last != -1) {
                s = s.substring(0, last) + '</g></svg>' + s.substring(last + 6);
              }
            }
          }
        }
      }
    } catch (_) {
      // best-effort: if anything fails here we keep original sanitized string
    }

    // If no explicit 'currentColor' usage was injected above, wrap content in
    // a default group that forces shapes to inherit the widget color. This
    // helps when the original SVG used classes/defs that were removed by the
    // sanitizer, leaving shapes uncolored (defaulting to black).
    try {
      if (!s.contains('currentColor')) {
        s = s.replaceFirstMapped(
            RegExp(r'<svg[^>]*>', caseSensitive: false),
            (m) =>
                '${m.group(0)}<g fill="currentColor" stroke="currentColor">');
        if (!s.contains('</g></svg>')) {
          final last = s.lastIndexOf('</svg>');
          if (last != -1) {
            s = s.substring(0, last) + '</g></svg>' + s.substring(last + 6);
          }
        }
      }
    } catch (_) {}

    // Ensure the SVG has a viewBox. flutter_svg requires either a viewBox or
    // explicit width/height to determine the coordinate system. Some exported
    // SVGs lose their viewBox after sanitizer removals; add a safe default
    // viewBox="0 0 512 512" if none is present to avoid the runtime error
    // "SVG did not specify dimensions". This is a conservative fallback and
    // only applied when no viewBox exists.
    try {
      final svgOpenMatch =
          RegExp(r'<svg[^>]*>', caseSensitive: false).firstMatch(s);
      if (svgOpenMatch != null) {
        final openTag = svgOpenMatch.group(0)!;
        if (!RegExp(r'viewBox\s*=\s*"', caseSensitive: false)
            .hasMatch(openTag)) {
          final replacement =
              openTag.replaceFirst('<svg', '<svg viewBox="0 0 512 512"');
          s = s.replaceFirst(openTag, replacement);
        }
      }
    } catch (_) {}

    return s.trim();
  }

  // Static top-level compatible sanitizer for compute()
  static String _sanitizeSvgStringStatic(String raw) {
    final ab = AssetButton(text: '', asset: null);
    return ab._sanitizeSvgString(raw);
  }

  // Helper that runs the sanitize operation off the main thread.
  // Returns the sanitized SVG string or null on failure.
  static Future<String?> loadAndSanitizeAssetOffThread(
      AssetBundle bundle, String assetPath) async {
    try {
      final sanitizedPath =
          assetPath.replaceAll(RegExp(r"\.svg\$"), '.sanitized.svg');
      ByteData? bd;
      try {
        bd = await bundle.load(sanitizedPath);
      } catch (_) {
        try {
          bd = await bundle.load(assetPath);
        } catch (_) {
          bd = null;
        }
      }
      if (bd == null) return null;
      final bytes = bd.buffer.asUint8List();
      final raw = utf8.decode(bytes);
      final sanitized = await compute(_sanitizeSvgStringStatic, raw);
      return sanitized;
    } catch (_) {
      return null;
    }
  }

  /// Precalienta en background la caché de SVGs sanitizados cargando
  /// todos los assets que cumplan con el prefijo indicado desde AssetManifest.
  /// Útil para evitar jank en la primera vez que se usan los íconos.
  static Future<void> prewarmAllSvgAssets(BuildContext context,
      {String prefix = 'assets/icons/buttons/'}) async {
    try {
      final bundle = DefaultAssetBundle.of(context);
      final manifestJson = await bundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(manifestJson);
      final List<String> svgPaths = manifest.keys
          .where((k) => k.startsWith(prefix))
          .where((k) => k.toLowerCase().endsWith('.svg'))
          .toList();
      // Limitar concurrencia simple para no saturar el hilo IO
      const int batchSize = 6;
      for (int i = 0; i < svgPaths.length; i += batchSize) {
        final batch = svgPaths.skip(i).take(batchSize).toList();
        await Future.wait(
            batch.map((p) => loadAndSanitizeAssetOffThread(bundle, p)));
      }
    } catch (_) {
      // best-effort, ignorar fallos silenciosamente
    }
  }

  /// Variante que no requiere BuildContext: usa rootBundle para leer el
  /// AssetManifest y los bytes. Ideal para iniciar el prewarm lo antes posible.
  static Future<void> prewarmAllSvgAssetsFromRootBundle(
      {String prefix = 'assets/icons/buttons/'}) async {
    try {
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(manifestJson);
      final List<String> svgPaths = manifest.keys
          .where((k) => k.startsWith(prefix))
          .where((k) => k.toLowerCase().endsWith('.svg'))
          .toList();
      const int batchSize = 6;
      for (int i = 0; i < svgPaths.length; i += batchSize) {
        final batch = svgPaths.skip(i).take(batchSize).toList();
        await Future.wait(
            batch.map((p) => loadAndSanitizeAssetOffThread(rootBundle, p)));
      }
    } catch (_) {}
  }

  // _loadPreferSanitizedAsset is no longer used; sanitization now happens
  // off-thread via _loadAndSanitizeAssetOffThread which directly uses the
  // DefaultAssetBundle to load the bytes and compute() to sanitize.
}
