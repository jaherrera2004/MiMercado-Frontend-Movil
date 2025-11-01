import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_mercado/core/utils/shared_preferences_utils.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onCartPressed;

  const HomeAppBar({
    super.key,
    this.onCartPressed,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final name = await SharedPreferencesUtils.getUserName();
      if (!mounted) return;
      setState(() {
        _userName = name;
      });
    } catch (e) {
      // Ignore errors, keep null
      print('Error loading user name: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = (_userName != null && _userName!.trim().isNotEmpty)
        ? _userName!.trim().split(' ').first
        : 'Usuario';

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const SizedBox(width: 4),
          const SizedBox(width: 10),
          Text(
            'Bienvenido, $displayName',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
        ],
      ),
      actions: [
        IconButton(
          icon: Image.asset(
            'lib/resources/carrito_icon.png',
            height: 40,
            width: 40,
          ),
          onPressed: widget.onCartPressed ?? () {
            Navigator.pushNamed(context, '/carrito');
          },
        ),
      ],
    );
  }
}