import java.awt.*;
import java.util.*;
import java.io.*;
import javax.swing.*;
import java.awt.image.*;

public class Week_2_main {
	public static void main(String[] args) {
		DrawingPanel p = new DrawingPanel(1000, 600);
		DistanceEstimation dm = new DistanceEstimation();
		//p.setBackground(Color.BLACK);
        Graphics g = p.getGraphics();
        int originX = 1000 / 2;
        int originY = 600 / 2;
        //g.drawLine(originX, 0, originX, 600);
        //g.drawLine(0, originY, 1000, originY);
        InJulia julia = new InJulia();
	    Set<Complex> complexNums = julia.julia(-2.0, -2.0, 2.0, 2.0, 0.005);
        System.out.println(complexNums.size());
        for (Complex z : complexNums) {
	    	double distance = dm.set_distance(-1, 0, z.re(),z.im());
	    	//System.out.println(distance);
	    	int colorGradient = Math.max(200 - (int)(500 * distance), 0);
	    	Color c = new Color(colorGradient, colorGradient, colorGradient);
	    	//int gradient = c.getRGB();
	    	int x = originX + (int) (300 * z.re());
	    	int y = originY + (int) (300 * z.im());
	    	g.setColor(c);
	    	g.drawOval(x, y, 1, 1);
        }
        
        
        //File outputfile = new File("image.png");
        //ImageIO.write(img, "png", outputfile);
//        frame.add(new JLabel(new ImageIcon(img)));
//        frame.setVisible(true);
//        frame.repaint();
//        frame.pack();
    //frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
 }
 
 private static void drawRandomValues(BufferedImage img) {
    Random rand = new Random();
    for (int x = 0; x < 1000; x++) {
       for (int y = 0; y < 600; y++) {
          if (rand.nextBoolean()) {
             img.setRGB(x, y, Color.BLACK.getRGB());
          }
       }
    }
 }
}
