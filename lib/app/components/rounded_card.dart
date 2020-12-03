part of app;

class RoundedCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final Color color;
  RoundedCard({
    this.child,
    this.radius = 8.0,
    this.padding = const EdgeInsets.all(4),
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: this.color ?? Theme.of(context).cardColor,
      margin: this.padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.radius ?? 8),
      ),
      child: child,
    );
  }
}