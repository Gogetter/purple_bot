import 'package:flutter/material.dart';

class AppToolbar extends StatelessWidget implements PreferredSizeWidget {
  const AppToolbar({
    Key key,
    this.leading,
    @required this.title,
    this.actions,
  }) : super(key: key);

  final Widget leading;
  final String title;
  final List<Widget> actions;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_bar',
      child: AppBar(
        leading: leading,
        title: Text(title),
        actions: actions,
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  const RatingBar({
    Key key,
    @required this.rating,
    this.color = Colors.amber,
  }) : super(key: key);

  final double rating;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (int index) {
        IconData icon = Icons.star_border;
        if (index < rating.floor()) {
          icon = Icons.star;
        } else if (index + 0.5 <= rating) {
          icon = Icons.star_half;
        }
        return Icon(icon, color: color);
      }),
    );
  }
}
