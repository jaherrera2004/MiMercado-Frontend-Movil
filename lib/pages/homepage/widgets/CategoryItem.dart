import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryItem extends StatelessWidget {
  final Map<String, dynamic> categoria;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.categoria,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String img = categoria["img"] ?? '';
    final bool isNetwork = img.startsWith('http://') || img.startsWith('https://');

    Widget avatar;
    if (isNetwork) {
      final encoded = Uri.encodeFull(img);
      avatar = CachedNetworkImage(
        imageUrl: encoded,
        imageBuilder: (context, imageProvider) {
          return CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            backgroundImage: imageProvider,
          );
        },
        placeholder: (context, url) => CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          child: const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          backgroundImage: const AssetImage('lib/resources/temp/image.png'),
        ),
      );
    } else {
      avatar = CircleAvatar(
        backgroundColor: Colors.grey[200],
        radius: 30,
        backgroundImage: AssetImage(img),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            avatar,
            const SizedBox(height: 5),
            Text(categoria["label"]),
          ],
        ),
      ),
    );
  }
}