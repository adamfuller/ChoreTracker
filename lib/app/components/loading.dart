part of app;

class Loading extends StatelessWidget {
  final Color color;
  Loading({
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    if (color != null) return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(color)));
    return const Center(child: const CircularProgressIndicator());
  }
}