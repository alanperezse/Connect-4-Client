class Info {
  final width;
  final height;
  final strategies;

  Info(this.width, this.height, this.strategies);

  @override
  String toString() {
    return 'Width: $width, Height: $height, Strategies: [${strategies.join(', ')}]';
  }
}