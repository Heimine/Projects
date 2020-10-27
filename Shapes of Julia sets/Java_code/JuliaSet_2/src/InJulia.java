import java.util.*;

public class InJulia{
   
   //public static double abs;
   //public static boolean inSet = true;
   public final int xDim = 1000;
   public final int yDim = 600;
   public final int FACTOR = 300;
   
   public InJulia() {
	   
   }
   // This method takes a given complex r as parameter and could 
   // determine whether this r is in the given Julia set or not.
   public boolean inJulia(Complex r) {
      boolean inSet = true;
      double abs = 0.0;
      for (int i = 0; i < 20; i++) {
         // System.out.println(r.abs());
         r = new Complex(r.times(r).re() - 1, r.times(r).im());
         abs = r.abs();
         //if (Double.isInfinite(abs)) {
         if (abs > 2) {   
         	inSet = false;
         }
      }
      return inSet;
   }
   
   public Set<Complex> julia(double negativeX, double negativeY, double x, double y, double spacing) {
      Set<Complex> complexNums = new HashSet<Complex>();
      for (double i = negativeX; i <= x; i += spacing) {
         for (double j = negativeY; j <= y; j += spacing) {
            i = round(i);
            j = round(j);
            //System.out.println(i + " " + j);
            Complex z = new Complex(i, j);
            DistanceEstimation dem = new DistanceEstimation();
            double distance = dem.set_distance(-1, 0, i, j);
            //if (distance < 0) {
            if (distance > 0 && distance < 10) {
               complexNums.add(z);
               // System.out.println(i + " " + j);
            }
         }
      }
      return complexNums;
   }
   
   public double round(double d) {
      int x = (int) (d * 1000);
      double y = x / 1000.0;
      return y;
   }

/*   public static void main(String[] args) {
      DrawingPanel p = new DrawingPanel(xDim, yDim);
      Graphics g = p.getGraphics();
      int originX = xDim / 2;
      int originY = yDim / 2;
      g.drawLine(originX, 0, originX, yDim);
      g.drawLine(0, originY, xDim, originY);
      Set<Complex> complexNums = julia(-2.0, -2.0, 2.0, 2.0, 0.005);
      System.out.println(complexNums.size());
      g.setColor(Color.ORANGE);
      for (Complex z : complexNums) {
         g.drawOval(originX + (int) (FACTOR * z.re()), originY + (int) (FACTOR * z.im()), 1, 1);
      }
   }*/
}