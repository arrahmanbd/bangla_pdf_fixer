import 'package:flutter/services.dart';
import 'package:pdf_text_shaper/pdf_text_shaper.dart';

/// Lazily loads and caches shaped fonts from Flutter assets.
///
/// The cache is scoped by both [AssetBundle] identity and asset path, so the
/// same path can safely be loaded from different bundles in tests or modular
/// applications.
final class BanglaFontManager {
  BanglaFontManager._();

  static final BanglaFontManager instance = BanglaFontManager._();

  final Map<_AssetFontKey, Future<ShapedFont>> _cache =
      <_AssetFontKey, Future<ShapedFont>>{};

  /// Loads a Unicode/OpenType font from a Flutter asset.
  ///
  /// Concurrent calls for the same bundle + asset path share one load. Failed
  /// loads are evicted automatically so a later call can retry.
  Future<ShapedFont> loadAsset(
    String assetPath, {
    AssetBundle? bundle,
    String? name,
  }) async {
    if (assetPath.trim().isEmpty) {
      throw ArgumentError.value(assetPath, 'assetPath', 'Cannot be empty.');
    }

    final effectiveBundle = bundle ?? rootBundle;
    final key = _AssetFontKey(effectiveBundle, assetPath);

    final cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    final future = _loadAsset(assetPath, bundle: effectiveBundle, name: name);

    _cache[key] = future;

    try {
      return await future;
    } catch (_) {
      if (identical(_cache[key], future)) {
        _cache.remove(key);
      }
      rethrow;
    }
  }

  /// Preloads several assets and returns them in the same order.
  Future<List<ShapedFont>> preloadAssets(
    Iterable<String> assetPaths, {
    AssetBundle? bundle,
  }) {
    return Future.wait(
      assetPaths.map((path) => loadAsset(path, bundle: bundle)),
    );
  }

  /// Backwards-compatible convenience for preloading one default font.
  Future<ShapedFont> initialize({
    required String defaultFontAsset,
    AssetBundle? bundle,
  }) {
    return loadAsset(defaultFontAsset, bundle: bundle, name: 'Bangla default');
  }

  /// Returns whether an asset is currently cached.
  bool isCached(String assetPath, {AssetBundle? bundle}) {
    return _cache.containsKey(_AssetFontKey(bundle ?? rootBundle, assetPath));
  }

  /// Removes and disposes one cached font.
  ///
  /// Returns `true` when a cache entry existed.
  Future<bool> evict(String assetPath, {AssetBundle? bundle}) async {
    final future = _cache.remove(
      _AssetFontKey(bundle ?? rootBundle, assetPath),
    );

    if (future == null) {
      return false;
    }

    try {
      final font = await future;
      font.dispose();
    } catch (_) {
      // The failed load is already removed. Nothing remains to dispose.
    }

    return true;
  }

  /// Disposes every successfully loaded cached font and clears the cache.
  ///
  /// A failed font future does not prevent the remaining fonts from being
  /// disposed.
  Future<void> dispose() async {
    final pending = _cache.values.toList(growable: false);
    _cache.clear();

    final disposed = <ShapedFont>{};

    for (final future in pending) {
      try {
        final font = await future;
        if (disposed.add(font)) {
          font.dispose();
        }
      } catch (_) {
        // Ignore failed loads while cleaning up the remaining fonts.
      }
    }
  }

  Future<ShapedFont> _loadAsset(
    String assetPath, {
    required AssetBundle bundle,
    String? name,
  }) async {
    final data = await bundle.load(assetPath);

    return ShapedFont.fromBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      name: name ?? assetPath,
    );
  }
}

final class _AssetFontKey {
  const _AssetFontKey(this.bundle, this.assetPath);

  final AssetBundle bundle;
  final String assetPath;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _AssetFontKey &&
            identical(bundle, other.bundle) &&
            assetPath == other.assetPath;
  }

  @override
  int get hashCode => Object.hash(identityHashCode(bundle), assetPath);
}
