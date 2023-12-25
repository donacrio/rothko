double boundedRandomGaussian(double mean, double sigma, double min, double max) {
  double sample = mean * (1 + sigma * randomGaussian());
  while(sample < min || sample > max) {
    sample = mean * (1 + sigma * randomGaussian());
  }
  return sample;
}
