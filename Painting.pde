import java.util.Comparator;
import java.util.List;

class Painting {
  HashMap<Integer, ArrayList<Watercolor>> layers;
  
  Painting() {
    this.layers = new HashMap<Integer, ArrayList<Watercolor>>();
  }
  
  void addToLayer(Integer i, Watercolor watercolor) {
    ArrayList<Watercolor> layer = this.layers.getOrDefault(i, new ArrayList<Watercolor>());
    layer.add(watercolor);
    this.layers.put(i, layer);
  }
  
  void render() {
    for(ArrayList<Watercolor> layer : this.layers.values()) {
      int maxSize = layer.stream().mapToInt(watercolor -> watercolor.shape.size()).max().getAsInt();
      println(maxSize);
      int i = 0;
      while(i < maxSize) {
        for(Watercolor watercolor : layer) {
          for(int j=0; j<5; j++) {
            if(i+j < watercolor.shape.size()) {
              Polygon polygon = watercolor.shape.get(i+j);
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
        i+=5;
      }
    }
  }
}
