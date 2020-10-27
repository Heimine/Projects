import java.awt.*;
import java.io.*;
import java.util.*;

public class LejaPlotter extends JuliaSetPlotter{
   private final int WIDTH = 1000;
   private final int HEIGHT = 1000;
   //the smaller the spacing, the larger the Julia Set
   private final double SPACING = 0.005;
   private static final int NUM_LEJA_POINTS = 1200;
   public static double S = 1.0 / NUM_LEJA_POINTS;
   private LejaPoints lp;
   private final int BRIGHTENING = 2;
   private final int DARKENING = 100;
   private double lejaPolynomialConstant;
   private Picture img;
   private Complex[][] allPoints;
   private InJulia inJulia;
   
   public static void main(String[] args) throws FileNotFoundException{
      LejaPlotter jsp = new LejaPlotter();
      Map<Complex, int[]> points = jsp.getSquare();
      jsp.drawShape(points, Color.GREEN);
      Set<Complex> complexNumbers = points.keySet();
     Complex firstLeja = complexNumbers.iterator().next();
      LejaPoints lps = new LejaPoints(complexNumbers, firstLeja); //TODO remove
      
//      jsp.outputAllPoints();
      jsp.setLejaPoints(lps); //TODO remove
      jsp.drawLejaPoints(NUM_LEJA_POINTS, points); //TODO remove
//      lps.polynomial(new Complex(1, 1), 1);
      
     //jsp.drawAllPointsExcept(points);
     //jsp.drawAllPoints();
      jsp.drawAllPointsObvious();
   }
   
   public LejaPlotter() {
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
            double distance = inJulia.distanceFromJuliaSet(z);
            //System.out.println(distance);
            if (distance > 0) {
            	if (distance > 5) {
            		System.out.println("hello world");
            	} else {
            		System.out.println("hi world");
            	}
            
               if (distance < 1) {
                  //int magnitude = (int) (1 / distance) * BRIGHTENING;
                  //drawBrighteningPoint(img, x, y, magnitude, Color.BLACK);
            	   img.set(x, y, Color.CYAN);
               } else {
                  int magnitude = (int) ((distance - 1) * DARKENING);
                  drawDarkeningPoint(img, x, y, magnitude,  Color.BLUE);
               }
            } else {
               img.set(x, y, Color.RED);
            }
         }
      }
      img.save("juliaTest2.png");
   }
   
   private void drawAllPointsObvious() {
	   for (int x = 0; x < WIDTH; x++) {
	         for (int y = 0; y < HEIGHT; y++) {
	        	 Complex z = allPoints[x][y];
	        	 if (inJulia.isFarFromJuliaSet(z)) {
	        		 img.set(x, y, Color.BLUE);
	        	 } else {
	        		 img.set(x, y, Color.RED);
	        	 }
	         }
	   }
	   img.save("obviousJulia.png");
   }
   
   private void drawAllPointsExcept(Map<Complex, int[]> points) {
      for (int x = 0; x < WIDTH; x++) {
         for (int y = 0; y < HEIGHT; y++) {
            Complex z = allPoints[x][y];
            if (!points.containsKey(z)) {
            	if (inJulia.isFarFromJuliaSet(z)) {
                    img.set(x, y, Color.BLUE);
            	} else {
                    img.set(x, y, Color.RED);
                }
            	/*double distance = inJulia.distanceFromJuliaSet(z);
            	if (x == 300 && y == 940) {
            		inJulia.isFarFromJuliaSet(z);
            		System.out.print(y);
            		System.out.print("  , ");
            		System.out.println(distance);
            		
            	}
                if (distance > 0) {
                	if (distance < 1) {
                		int magnitude = (int) (1 / distance) * BRIGHTENING;
                        drawBrighteningPoint(img, x, y, magnitude, Color.BLUE);
                	} else {
                        int magnitude = (int) ((distance/10) * DARKENING);
                        drawDarkeningPoint(img, x, y, magnitude,  Color.BLUE);
                	}
    
                }else{
                    img.set(x, y, Color.RED);
                }*/
            }
         }
         System.out.println(x);//TODO remove
      }
      img.save("ISM_1000.png");
   }
   
   private void drawLejaPoints(int numLejaPoints, Map<Complex, int[]> points) {
      for (int n = 1; n < numLejaPoints; n++) {
         Complex nextLeja = this.lp.getNextLejaPoint();
         int[] point = points.get(nextLeja);
         img.set(point[0], point[1], Color.MAGENTA);
      }
      for (Complex leja : this.lp.lejaPoints) {
         System.out.println(leja);
      }
      this.lejaPolynomialConstant = Math.exp(-1 * NUM_LEJA_POINTS * S / 2);
      System.out.println("lejaPolynomialConstant: " + this.lejaPolynomialConstant);
      System.out.println("cap(E): " + this.lp.getCapE());
      //this.img.save("leja.png");
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
      
      
      
     /*for (int x = WIDTH / 30 * 21; x < 24 * WIDTH / 30; x++) {
    	  int y = 9 * HEIGHT / 10;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int x = 26 * WIDTH / 30; x < 29 * WIDTH / 30; x++) {
    	  int y = 9 * HEIGHT / 10;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int y = HEIGHT / 10; y < 9 * HEIGHT / 10; y++) {
    	  int x = 21 * WIDTH / 30;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
    	  x = 29 * WIDTH / 30;
    	  z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int x = 21 * WIDTH / 30; x < 22 * WIDTH / 30; x++) {
    	  int y = HEIGHT / 10;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int x = 28 * WIDTH / 30; x < 29 * WIDTH / 30; x++) {
    	  int y = HEIGHT / 10;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int y = HEIGHT / 10; y < 7 * HEIGHT / 10; y++) {
    	  int x = 22 * WIDTH / 30;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
    	  x = 28 * WIDTH / 30;
    	  z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int x = 22 * WIDTH / 30; x < 25 * WIDTH / 30; x++) {
    	  int y = -2 * x + 5100;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int x = 25 * WIDTH / 30; x < 28 * WIDTH / 30; x++) {
    	  int y = 2 * x - 4900;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int x = 24 * WIDTH / 30; x < 25 * WIDTH / 30; x++) {
    	  int y = -4 * x + 10500;//2500
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int x = 25 * WIDTH / 30; x < 26 * WIDTH / 30; x++) {
    	  int y = 4 * x - 9500;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      
      for (int x = WIDTH/30 * 3; x < WIDTH / 30 * 7; x++) {
          int y = HEIGHT / 10;
          Complex z = this.allPoints[x][y];
          points.put(z, new int[] {x,y});
          y = HEIGHT / 10 * 9;
          z = this.allPoints[x][y];
          points.put(z, new int[] {x,y});
      }
      for (int y = HEIGHT / 10; y < 2 * HEIGHT / 10; y++) {
    	  int x = 3 * WIDTH / 30;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
    	  x = 7 * WIDTH / 30;
    	  z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int y = HEIGHT / 10 * 8; y < 9 * HEIGHT / 10; y++) {
    	  int x = 3 * WIDTH / 30;
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
    	  x = 7 * WIDTH / 30;
    	  z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int x = WIDTH/30 * 3; x < WIDTH / 30 * 4; x++) {
          int y = HEIGHT / 10 * 2;
          Complex z = this.allPoints[x][y];
          points.put(z, new int[] {x,y});
          y = HEIGHT / 10 * 8;
          z = this.allPoints[x][y];
          points.put(z, new int[] {x,y});
      }
      for (int x = WIDTH/30 * 6; x < WIDTH / 30 * 7; x++) {
          int y = HEIGHT / 10 * 2;
          Complex z = this.allPoints[x][y];
          points.put(z, new int[] {x,y});
          y = HEIGHT / 10 * 8;
          z = this.allPoints[x][y];
          points.put(z, new int[] {x,y});
      }
      for (int y = HEIGHT / 10 * 2; y < 8 * HEIGHT / 10; y++) {
    	  int x = 4 * WIDTH / 30;
    	  
    	  Complex z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
    	  x = 6 * WIDTH / 30;
    	  z = this.allPoints[x][y];
    	  points.put(z,  new int[] {x , y});
      }
      for (int x =  (int) ((int) WIDTH / 30 * 13.75); x < ((int) WIDTH / 30 * 16.25); x++) {
      	int y = (int) (-1 * Math.sqrt(125 * 125 - Math.pow(x - 1500, 2)) + 325);
      	Complex z = this.allPoints[x][y];
  	    points.put(z,  new int[] {x , y});
  	    if (x < WIDTH/ 30 * 15) {
  	    	int y_2 = -1 * (y - 325) + 325;
  	    	z = this.allPoints[x][y_2];
  	  	    points.put(z,  new int[] {x , y_2});
  	    }
      }
      for (int x =  (int) ((int) WIDTH / 30 * 12.75); x < ((int) WIDTH / 30 * 17.25); x++) {
  	    int y = (int) (-1 * Math.sqrt(225 * 225 - Math.pow(x - 1500, 2)) + 325);
    	Complex z = this.allPoints[x][y];
	    points.put(z,  new int[] {x , y});
	    if (x < WIDTH/ 30 * 15) {
	    	int y_2 = -1 * (y - 325) + 325;
	    	z = this.allPoints[x][y_2];
	  	    points.put(z,  new int[] {x , y_2});
	    }
      }
      for (int x =  (int) ((int) WIDTH / 30 * 13.75); x < ((int) WIDTH / 30 * 16.25); x++) {
        	int y = (int) (Math.sqrt(125 * 125 - Math.pow(x - 1500, 2)) + 675);
        	Complex z = this.allPoints[x][y];
    	    points.put(z,  new int[] {x , y});
    	    if (x > WIDTH/ 30 * 15) {
    	    	int y_2 = -1 * (y - 675) + 675;
    	    	z = this.allPoints[x][y_2];
    	  	    points.put(z,  new int[] {x , y_2});
    	    }
      }
      for (int x =  (int) ((int) WIDTH / 30 * 12.75); x < ((int) WIDTH / 30 * 17.25); x++) {
    	int y = (int) (Math.sqrt(225 * 225 - Math.pow(x - 1500, 2)) + 675);
      	Complex z = this.allPoints[x][y];
  	    points.put(z,  new int[] {x , y});
  	    if (x > WIDTH/ 30 * 15) {
  	    	int y_2 = -1 * (y - 675) + 675;
  	    	z = this.allPoints[x][y_2];
  	  	    points.put(z,  new int[] {x , y_2});
  	     }
       }
      for (int x =  (int) ((int) WIDTH / 30 * 12.75); x < ((int) WIDTH / 30 * 13.75); x++) {
    	  int y = 675;
      	Complex z = this.allPoints[x][y];
	    points.put(z,  new int[] {x , y});
      }
      for (int x =  (int) ((int) WIDTH / 30 * 16.25); x < ((int) WIDTH / 30 * 17.25); x++) {
    	  int y = 325;
      	Complex z = this.allPoints[x][y];
	    points.put(z,  new int[] {x , y});
      }*/
      return points;
   } 

   /*private Map<Complex, int[]> getSquare() throws FileNotFoundException {
       Map<Complex, int[]> points = new HashMap<Complex, int[]>();
       File data = new File("Try.txt");
       Scanner input = new Scanner(data);
       System.out.println("...");
       while (input.hasNext()) {
    	   System.out.println("...");
    	   int x = (int)input.nextDouble();
    	   int y = (int)input.nextDouble();
    	   System.out.println(x + " " + y);
    	   Complex z = this.allPoints[x][y];
    	   points.put(z, new int[] {x, y});
       }
       return points;
   }*/
   
   private void drawShape(Map<Complex, int[]> points, Color c) {
      for (Complex z : points.keySet()) {
         int[] point = points.get(z);
         //this.img.set(point[0], point[1], c);
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
      img.set(x, y, c);;
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
      return r.times(r).plus(new Complex(-0.8, 0.156));
   }
   
   /*public Complex polynomial(Complex r) {
     return this.lp.polynomial(r, this.lejaPolynomialConstant);
   }*/
}