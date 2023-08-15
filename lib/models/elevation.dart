class Elevation {
  double min;
  double max;
  Elevation(this.min, this.max);

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}
