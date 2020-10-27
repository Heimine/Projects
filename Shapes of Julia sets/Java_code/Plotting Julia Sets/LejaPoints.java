import java.util.*;

/**
 * @author Xiao Li
 * @author RyanPachauri
 * 
 */
public class LejaPoints {
   //we need to keep track of all the points that the user wants the shape of
   //map of every point in the shape to a double representing their max
   // helps in calculating the next leja point
   private Map<Complex, Double> allPoints;
   public List<Complex> lejaPoints;
   private Complex firstLejaPoint;
   private double capE;
   
   /**
    * Initializes this LejaPoints instance to make sure that it stores all the
    *    necessary points for creating the shape
    * 
    * @param points     Set of all points representing a shape we'd like to create
    * @param lejaPoint  Complex number that we'd like to have as our first lejaPoint
    * @throws IllegalArgumentException if lejaPoint is not in points
    */
   public LejaPoints(Set<Complex> points, Complex lejaPoint) {
      if (!points.contains(lejaPoint)) {
         throw new IllegalArgumentException();
      }
      this.allPoints = new HashMap<Complex, Double>();
      for (Complex z : points) {
         this.allPoints.put(z, 1.0);
      }
      this.lejaPoints = new ArrayList<Complex>();
      this.firstLejaPoint = lejaPoint;
      this.lejaPoints.add(this.firstLejaPoint);
   }
   
   /**
    * Assumes that this instance contains at least one leja point
    * Finds the next leja point and adds it to this set of leja points
    * @return the next Complex number in this
    * @throws IllegalStateException if lejaPoints is empty
    */
   public Complex getNextLejaPoint() {
      if (this.lejaPoints.isEmpty()) {
         throw new IllegalStateException();
      }
      double max = -1;
      //has to be set to a dummy value in order to compile
      Complex nextLejaPoint = new Complex(0, 0);
      for (Complex z : this.allPoints.keySet()) {
         //only need to multiply the difference between z and the last leja point
         //because we store those multiples
         Complex lastLejaPoint = this.lejaPoints.get(this.lejaPoints.size() - 1);
         double diff = z.minus(lastLejaPoint).abs();
         double product = this.allPoints.get(z) * Math.pow(diff, LejaPlotter.S);
         this.allPoints.put(z, product);
         if (max < product) {
            max = product;
            nextLejaPoint = z;
         }
      }
      this.capE = max;
      this.lejaPoints.add(nextLejaPoint);
      //since we add it to lejaPoints, we don't need it when calculating anymore
      this.allPoints.remove(nextLejaPoint);
      return nextLejaPoint;
   }
   
   public double getCapE() {
      return this.capE;
   }
   
   /**
    * This polynomial is defined by Malik Younsi. For more information, please
    *    refer to his research
    * 
    * @param z a Complex number passed into the function
    * @return  the Complex number as a result of z being put through this
    *          function
    */
   public Complex polynomial(Complex z, double x) {
      Complex result = new Complex(1,1);
//      System.out.println("x: " + x);//TODO remove
      for (Complex leja : this.lejaPoints) {
         result = result.times(z.minus(leja));
         result = new Complex(result.re() / this.capE, result.im() / this.capE);
//         System.out.println("\t" + result);//TODO
      }
      //System.out.println(result);
      //System.out.println(this.capE);
      result.times(z);
      return new Complex(result.re() * x, result.im() * x);
   }
}
