class Painting {
  ArrayList<Watercolor> watercolors;
  
  Painting() {
    this.watercolors = new ArrayList<Watercolor>();
  }
  
  void addWatercolor(Watercolor watercolor) {
    this.watercolors.add(watercolor);
  }
  
  void render() {
    for(Watercolor watercolor : this.watercolors) {
      for(Polygon polygon : watercolor.shape) {
        noStroke();
        fill(watercolor.c, 10);
        beginShape();
        for(Coordinate coord : polygon.getExteriorRing().getCoordinates()) {
          vertex((float)coord.x, (float) coord.y);
        }
        endShape();
      }
    }
  }
}
