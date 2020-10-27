/**
 * @author Xiao Li
 * @author RyanPachauri
 *
 * This class will determine if a point is in a Julia Set using the following
 *    methods:
 *    1. Straightforward method:
 *       -  Iterate a polynomial a certain number of times to see if the
 *          point diverges:
 *    2. Distance estimation method:
 *       -  Calculate the distance a complex number is from a Julia Set
 */
public class InJulia {
   //increasing this makes fewer points in the Julia Set
   private static final double FAR_ENOUGH = 10.0;
   //increasing this makes fewer points in the Julia Set
   private static final int NUM_ITERATIONS = 50;
   private JuliaSetPlotter jsp;
   
   public InJulia(JuliaSetPlotter jsp) {
      this.jsp = jsp;
   }
   
   public boolean isFarFromJuliaSet(Complex z) {
      for (int i = 0; i < NUM_ITERATIONS; i++) {
         z = this.jsp.polynomial(z);
         //System.out.println(z.abs());
         if (z.abs() > FAR_ENOUGH) {
            return true;
         }
      }
      return false;
   }
   
   public double distanceFromJuliaSet(Complex z) {
      Complex dz = new Complex(1, 0);
      int cnt = 1;
      while (cnt < 200) {
         dz = new Complex(2, 0).times(z).times(dz);
         z = this.jsp.polynomial(z);
         if (z.abs() > 10) {
            break;
         }
         cnt++;
      }
      //System.out.println(dz);
      //System.out.println(z);
      //System.out.println(z.abs() * Math.log(z.abs()) / dz.abs());
      return z.abs() * Math.log(z.abs()) / dz.abs();
   }
}