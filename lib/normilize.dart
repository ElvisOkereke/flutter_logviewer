double normalizeData(double value, double min, double max) {
  //normalize data
  if (value < 0) {
    double normalizedValue = (value + max) / (max + min.abs());
    return normalizedValue * -1;
  }

  double normalizedValue = (value - min) / (max + min.abs());

  return normalizedValue;
}
