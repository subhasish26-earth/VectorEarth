import 'package:flutter/material.dart';
import '../core/constants/app_images.dart';
import 'shimmer_box.dart';

/// Universal image renderer for Prithvi Fix
/// Automatically handles:
/// 1. Local bundled asset (if present)
/// 2. High-res cloud fallback (if local not yet provided)
/// 3. Smooth shimmer skeleton while loading
/// 4. Graceful error fallback
class CustomImage extends StatelessWidget {
  final ImageAssetInfo? imageInfo;
  final String? assetPath;
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CustomImage({
    Key? key,
    this.imageInfo,
    this.assetPath,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (imageInfo != null) {
      content = Image.asset(
        imageInfo!.localPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildNetwork(imageInfo!.fallbackUrl),
      );
    } else if (assetPath != null) {
      content = Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    } else if (imageUrl != null) {
      content = _buildNetwork(imageUrl!);
    } else {
      content = _buildPlaceholder();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }

    return content;
  }

  Widget _buildNetwork(String url) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return ShimmerBox(
          width: width,
          height: height,
          borderRadius: borderRadius,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF1F5F9),
      child: Center(
        child: Icon(
          Icons.handyman_outlined,
          color: const Color(0xFF94A3B8),
          size: (height != null && height! < 60) ? 20 : 32,
        ),
      ),
    );
  }
}
