import java.awt.*;
import java.io.FileNotFoundException;
import java.util.*;

public class JuliaSetPlotter{
   private final int WIDTH = 1000;
   private final int HEIGHT = 1000;
   //the smaller the spacing, the larger the Julia Set
   private final double SPACING = 0.005;
   private static final int NUM_LEJA_POINTS = 0;
   private static double S = 1.0;
		   /// NUM_LEJA_POINTS;
   private LejaPoints lp;
   private final int BRIGHTENING = 15;
   private final int DARKENING = 100;
   private double lejaPolynomialConstant;
   
   private Picture img;
   private Complex[][] allPoints;
   private InJulia inJulia;
   
   public static void main(String[] args) throws FileNotFoundException{
      JuliaSetPlotter jsp = new JuliaSetPlotter();
      Map<Complex, int[]> points = jsp.getSquare();
      jsp.drawShape(points, Color.GREEN);
      Set<Complex> complexNumbers = points.keySet();
      Complex firstLeja = complexNumbers.iterator().next();
      LejaPoints lps = new LejaPoints(complexNumbers, firstLeja);
      
//      jsp.outputAllPoints();
      jsp.setLejaPoints(lps);
      //jsp.drawLejaPoints(NUM_LEJA_POINTS, points);
//      lps.polynomial(new Complex(1, 1), 1);
      jsp.drawAllPoints();
      //jsp.drawAllPointsExcept(points);
   }
   
   public JuliaSetPlotter() {
      this.img = new Picture(WIDTH,  HEIGHT);
      this.allPoints = this.createComplexValues();
      this.inJulia = new InJulia(this);
   }
   
   private void outputAllPoints() {
      for (int i = 0; i < this.allPoints.length; i++) {
         for (int j = 0; j < this.allPoints[0].length; j++) {
            System.out.println(this.allPoints[i][j]);
         }
      }
   }
   
   private void setLejaPoints(LejaPoints lps) {
      this.lp = lps;
   }
   
   private void drawAllPoints() {
      for (int x = 0; x < WIDTH; x++) {
         for (int y = 0; y < HEIGHT; y++) {
            Complex z = allPoints[x][y];
            double distance = inJulia.distanceFromJuliaSet(new Complex(-2,-2));
            System.out.println(distance);
            if (distance > 0) {
               if (distance < 1) {
                  int magnitude = (int) Math.log((1 / distance) * BRIGHTENING);
                  drawBrighteningPoint(img, x, y, magnitude, Color.BLUE);
               } else {
                  int magnitude = (int) ((distance - 1) * DARKENING);
                  drawDarkeningPoint(img, x, y, magnitude,  Color.BLUE);
               }
            } else {
               img.set(x, y, Color.BLACK);
            }
         }
      }
      img.save("juliaTest.png");
   }
   
   private void drawAllPointsExcept(Map<Complex, int[]> points) {
      for (int x = 0; x < WIDTH; x++) {
         for (int y = 0; y < HEIGHT; y++) {
            Complex z = allPoints[x][y];
            if (!points.containsKey(z)) {
               if (inJulia.isFarFromJuliaSet(z)) {
                  img.set(x, y, Color.BLUE);
               /*
               double distance = inJulia.distanceFromJuliaSet(z);
               if (distance > 0) {
                  if (distance < 1) {
                     int magnitude = (int) Math.log((1 / distance) * BRIGHTENING);
                     drawBrighteningPoint(img, x, y, magnitude, Color.BLUE);
                  } else {
//                     int magnitude = (int) ((distance - 1) * DARKENING);
                     int magnitude = 0;
                     drawDarkeningPoint(img, x, y, magnitude,  Color.BLUE);
                  }
                  */
               } else {
                  img.set(x, y, Color.RED);
               }
            }
         }
         System.out.println(x);//TODO remove
      }
      img.save("Square.png");
   }
   
   private void drawLejaPoints(int numLejaPoints, Map<Complex, int[]> points) {
      for (int n = 1; n < numLejaPoints; n++) {
         Complex nextLeja = this.lp.getNextLejaPoint();
         int[] point = points.get(nextLeja);
         img.set(point[0], point[1], Color.MAGENTA);
      }
      this.lejaPolynomialConstant = Math.exp(-1 * NUM_LEJA_POINTS * S / 2) / this.lp.getCapE();
      System.out.println("lejaPolynomialConstant" + this.lejaPolynomialConstant);
      this.img.save("leja.png");
   }
   
   private Complex[][] createComplexValues() {
      Complex[][] points = new Complex[WIDTH][HEIGHT];
      for (int x = - WIDTH / 2; x < WIDTH / 2; x++) {
         for (int y = - HEIGHT / 2; y < HEIGHT / 2; y++) {
            double re = round(x * SPACING);
            double im = round(y * SPACING);
            points[x + WIDTH / 2][HEIGHT - (y + HEIGHT / 2) - 1] = new Complex(re, im);
         }
      }
      return points;
   }
   
   private static double round(double d) {
      int x = (int) (d * 1000);
      double y = x / 1000.0;
      return y;
   }
   
   /**
    * For this method, please make sure that WIDTH == HEIGHT
    */
   private Map<Complex, int[]> getSquare() {
      Map<Complex, int[]> points = new HashMap<Complex, int[]>();
      for (int x = WIDTH / 4; x < 3 * WIDTH / 4; x++) {
         int y = HEIGHT / 4;
         Complex z = this.allPoints[x][y];
         points.put(z, new int[] {x, y});
         y = 3 * HEIGHT / 4;
         z = this.allPoints[x][y];
         points.put(z, new int[] {x, y});
      }
      for (int y = WIDTH / 4; y < 3 * WIDTH / 4; y++) {
         int x = HEIGHT / 4;
         Complex z = this.allPoints[x][y];
         points.put(z, new int[] {x, y});
         x = 3 * HEIGHT / 4;
         z = this.allPoints[x][y];
         points.put(z, new int[] {x, y});
      }
      return points;
   }
   
   private void drawShape(Map<Complex, int[]> points, Color c) {
      for (Complex z : points.keySet()) {
         int[] point = points.get(z);
         this.img.set(point[0], point[1], c);
      }
   }
   
   private void drawBrighteningPoint(Picture img, int x, int y, int magnitude, Color c) {
      c = getBrighterColor(c, magnitude);
      img.set(x, y, c);
   }
   
   private Color getBrighterColor(Color c, int brighter) {
      int r = fixOverflow(Math.min(255, c.getRed() + brighter));
      int g = fixOverflow(Math.min(255, c.getGreen() + brighter));
      int b = fixOverflow(Math.min(255, c.getBlue() + brighter));
      return new Color(r, g, b);
   }
   
   private void drawDarkeningPoint(Picture img, int x, int y, int magnitude, Color c) {
      c = getDarkerColor(c, magnitude);
      img.set(x, y, c);
   }
   
   private Color getDarkerColor(Color c, int darker) {
      int r = Math.max(0, c.getRed() - darker);
      int g = Math.max(0, c.getGreen() - darker);
      int b = Math.max(0, c.getBlue() - darker);
      return new Color(r, g, b);
   }
   
   private int fixOverflow(int x) {
      if (x < 0) {
         return 255;
      }
      return x;
   }
   
   public Complex polynomial(Complex r) {
      return r.times(r).plus(new Complex(-1, 0));
   }
   
  /* public Complex polynomial(Complex r) {
      return this.lp.polynomial(r, this.lejaPolynomialConstant);
   }*/
}