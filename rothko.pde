import org.apache.commons.math3.distribution.PoissonDistribution;

GeometryFactory GF;
Polygon basePolygon;

void setup() {
  size(720, 720);
  
  GF = new GeometryFactory();
  
  try {
  WKTReader r = new WKTReader();
  basePolygon = (Polygon) r.read("POLYGON((1 0, 0.71 0.71, 0 1, -0.71 0.71, -1 0, -0.71 -0.71, 0 -1, 0.71 -0.71, 1 0))");
  } catch(ParseException e) {
    println(e);
  }
  
  AffineTransformation baseTransformation = new AffineTransformation();
  Point centroid = basePolygon.getCentroid();
  baseTransformation.translate(-centroid.getX(),-centroid.getY());
  double diameter = 2*(new MinimumBoundingCircle(basePolygon)).getRadius();
  baseTransformation.scale(0.4*width/diameter,0.4*height/diameter);
  baseTransformation.rotate(PI);
  basePolygon = (Polygon) baseTransformation.transform(basePolygon);
  
  //ArrayList<Polygon> painting = watercolor(basePolygon);
  
  //background(255);
  //translate(width/2, width/2);
  
  //for(Polygon polygon : painting) {
  //  noStroke();
  //  fill(132, 169, 140, 10);
  //  beginShape();
  //  for(Coordinate coord : polygon.getExteriorRing().getCoordinates()) {
  //    vertex((float)coord.x, (float) coord.y);
  //  }
  //  endShape();
  //}
  //noLoop();
}

void draw() {
  ArrayList<Polygon> painting = watercolor(basePolygon);

  background(255);
  translate(width/2, width/2);
  
  for(Polygon polygon : painting) {
    noStroke();
    fill(132, 169, 140, 10);
    beginShape();
    for(Coordinate coord : polygon.getExteriorRing().getCoordinates()) {
      vertex((float)coord.x, (float) coord.y);
    }
    endShape();
  }
  
  delay(1000);
}

ArrayList<Polygon> watercolor(Polygon polygon) {
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  Polygon basePolygon = polygon;
  basePolygon = watercolorStep(basePolygon);
  for(int i=0; i<60; i++) {
    if(i==20 || i ==40) {
      basePolygon = watercolorStep(basePolygon);
    }
    Polygon newPolygon = basePolygon;
    for(int j=0; j<3; j++) {
      newPolygon = watercolorStep(newPolygon);
    }
    polygons.add(newPolygon);
  }
  return polygons;
}

Polygon watercolorStep(Polygon polygon) {
  ArrayList<Coordinate> exteriorCoords = new ArrayList<Coordinate>();
  for(int i = 0; i < polygon.getExteriorRing().getCoordinates().length - 1; i++) {
    Vector2D curr = Vector2D.create(polygon.getExteriorRing().getCoordinateN(i));
    Vector2D next = Vector2D.create(polygon.getExteriorRing().getCoordinateN(i+1));
    
    // Random Gaussian start point centered on middle segment
    double weight = boundedRandomGaussian(0.5, 0.1, 0, 1);
    Vector2D mid = curr.multiply(weight).add(next.multiply(1-weight));
    // Random Gaussian direction
    double angle = boundedRandomGaussian(PI/2, PI/8, 0, PI);
    Vector2D direction = next.subtract(curr).rotate(-angle);
    // Magnitude centered around edge magnitude, always positive
    double magnitude = boundedRandomGaussian(0.5, 0.2, 0, 1);
    Vector2D newMid = mid.add(direction.multiply(magnitude));
    
    exteriorCoords.add(curr.toCoordinate());
    exteriorCoords.add(newMid.toCoordinate());
  }
  exteriorCoords.add(polygon.getExteriorRing().getCoordinateN(polygon.getExteriorRing().getCoordinates().length-1));
  // TODO : interior rings
  return GF.createPolygon(exteriorCoords.toArray(new Coordinate[0]));
}

double boundedRandomGaussian(double mean, double sigma, double min, double max) {
  double sample = mean * (1 + sigma * randomGaussian());
  while(sample < min || sample > max) {
    sample = mean * (1 + sigma * randomGaussian());
  }
  return sample;
}
