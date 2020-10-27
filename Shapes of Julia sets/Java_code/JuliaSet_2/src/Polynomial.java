import java.util.*;

public class Polynomial {
	
	public List<Complex> leja_points;
	public Set<Complex> all_points;
	public List<Complex> alpoints;
	public double width;
	public double height;
	public Complex origin;
	public double interval;
	public double distance;
	
	public Polynomial(double width, double height, Complex origin, double interval) {
		leja_points = new ArrayList<Complex>();
		all_points = new HashSet<Complex>();
		alpoints = new ArrayList<Complex>();
		this.width = width;
		this.height = height;
		this.origin = new Complex(origin.re(), origin.im());
		this.interval = interval;
		
	}
		
	public List<Complex> leja(int number) {
		Complex z_1 = origin;
		leja_points.add(z_1);
		distance = 0;
		double dis = 0;
		//Complex z_2 = new Complex(0,0);
		Complex z_n = new Complex(0,0);
		/*for (Complex z: all_points) {
			dis = z.minus(z_1).abs();
			if (dis > distance) {
				distance = dis;
				z_2 = z;
			}
		}*/
		for (int i = 0; i < number - 1; i++) {
			list_points();
			distance = 0;
			for (Complex z: alpoints) {
				dis = z.minus(z_1).abs();
				for (int j = 0; j < leja_points.size(); j++) {
					dis = dis * (z.minus(leja_points.get(j)).abs());
					//System.out.println(leja_points.get(j).toString());
				}
				if (dis > distance) {
					distance = dis;
					z_n = z;
					// System.out.println(z.toString());
				}
				dis = 1;
			}
			leja_points.add(z_n);
			z_n = new Complex(0,0);
			dis = 1;
		}
		System.out.println(leja_points.toString());

		return leja_points;
	}
	
	public Complex polynomialFromLejaPoints(Complex z) {
		//Complex newZ = new Comp
		return null;//TODO SOMETHING
		
	}
	
	public double round(double value, int places) {
	    if (places < 0) throw new IllegalArgumentException();

	    long factor = (long) Math.pow(10, places);
	    value = value * factor;
	    long tmp = Math.round(value);
	    return (double) tmp / factor;
	}
	
	public List<Complex> list_points() {
		alpoints.addAll(all_points);
		return alpoints;
	}
	
	public Set<Complex> points() {
		double x_0 = origin.re();
		double y_0 = origin.im();
		double x_n = x_0 + width;
		double y_n = y_0 + height;
		all_points.add(origin);
		all_points.add(new Complex(x_n, y_n));
		double x = x_0;
		for (int i = 0; i < (int)(width/interval) + 1; i++) {
			all_points.add(new Complex(round(x, 1), y_0));
			all_points.add(new Complex(round(x, 1), y_n));
			x+=interval;
		} 
		/*for (Complex e: all_points) {
			System.out.println(e.toString());
		}*/
		System.out.println(all_points.size());
		double y = y_0;
		for (int j = 0; j < (int)(height/interval) + 1; j++) {
			all_points.add(new Complex(x_0, round(y, 1)));
			all_points.add(new Complex(x_n, round(y, 1)));
			y+=interval;
		}
		System.out.println(all_points.size());
		
	    if (all_points.contains(new Complex (1.0, 0))) {
			System.out.println(0);
		}
		return all_points;
	}
	
	public double find_poly(int n, double s) {
		double xiao = Math.exp(-1 * n * s / 2) / distance;
		return xiao;
	}
	
	public double capE() {
		return distance;
	}
}
