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
  
  Painting painting = new Painting();
  Watercolor watercolor = new Watercolor(basePolygon, color(132, 169, 140));
  painting.addWatercolor(watercolor);
  
  background(255);
  translate(width/2, width/2);
  painting.render();
  
  noLoop();
}
