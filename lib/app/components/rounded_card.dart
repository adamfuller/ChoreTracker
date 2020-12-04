part of app;

class RoundedCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final Color color;
  final Key key;
  RoundedCard({
    this.key,
    this.child,
    this.radius = 8.0,
    this.padding = const EdgeInsets.all(4),
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      key: this.key,
      color: this.color ?? Theme.of(context).cardColor,
      margin: this.padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.radius ?? 8),
      ),
      child: child,
    );
  }
}