import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBack;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final bool showSearch;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBack = false,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.showSearch = false,
    this.onSearchChanged,
    this.searchHint,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.primary,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : leading,
      title: showSearch
          ? _SearchBar(
              onChanged: onSearchChanged,
              hint: searchHint ?? 'Search...',
            )
          : titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      elevation: 0,
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hint;

  const _SearchBar({this.onChanged, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        autofocus: true,
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.7)),
          prefixIcon: Icon(Icons.search, color: AppColors.white.withValues(alpha: 0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
