import java.util.List;

public class DistanceEstimation {
	public double set_distance(double cx, double cy, double z0x, 
			double z0y) {
		//Polynomial test = new Polynomial(2.0, 2.0, new Complex(-1.0, -1.0), 0.1);
		//test.points();
		//List<Complex> leja_points = test.leja(7);
		Complex z_new;
		Complex dz_new;
		Complex c = new Complex(cx,cy);
		Complex z = new Complex(z0x, z0y);
		Complex dz = new Complex(1, 0);
		int cnt = 1;
		//double first = test.find_poly(7, 0.1);
		while (cnt < 200) {
			/*z_new = z.times(new Complex(first, 0));
			for (int i = 0; i < leja_points.size(); i++) {
				z_new = z_new.times(z.minus(leja_points.get(i)));
			}*/
			z_new = z.times(z).plus(c);
			dz_new = new Complex(2, 0).times(z).times(dz);
			z = z_new;
			dz = dz_new;
			if (z.abs() > 10) {
				break;
			}
			cnt++;
		}
		return z.abs() * Math.log(z.abs()) / dz.abs();
	}
}
