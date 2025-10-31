import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> producto;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.producto,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Center(
                  child: _ProductImage(imagePath: producto["img"] as String),
                ),
                IconButton(
                  onPressed: onAddToCart,
                  icon: Image.asset(
                    'lib/resources/add_icon.png',
                    height: 28,
                    width: 28,
                  ),
                )
              ],
            ),
          ),
          Text(
            producto["nombre"],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              producto["precio"],
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imagePath;
  const _ProductImage({required this.imagePath});

  bool get _isNetwork => imagePath.startsWith('http://') || imagePath.startsWith('https://');
  static const double imageZoomScale = 1.5;

  @override
  Widget build(BuildContext context) {
    // Debug prints to diagnose why the image isn't loading
    if (imagePath.isEmpty) {
      return Transform.scale(
        scale: imageZoomScale,
        child: Image.asset(
          'lib/resources/temp/image.png',
          height: 80,
          fit: BoxFit.contain,
        ),
      );
    }

    if (_isNetwork) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        height: 80,
        fit: BoxFit.contain,
        placeholder: (context, url) {
          return Transform.scale(
            scale: imageZoomScale,
            child: const SizedBox(
              height: 80,
              width: 80,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          );
        },
        imageBuilder: (context, imageProvider) {
          return Transform.scale(
            scale: imageZoomScale,
            child: Image(
              image: imageProvider,
              height: 80,
              fit: BoxFit.contain,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Transform.scale(
            scale: imageZoomScale,
            child: Image.asset(
              'lib/resources/temp/image.png',
              height: 80,
              fit: BoxFit.contain,
            ),
          );
        },
      );
    }

    return Transform.scale(
      scale: imageZoomScale,
      child: Image.asset(
        imagePath,
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }
}