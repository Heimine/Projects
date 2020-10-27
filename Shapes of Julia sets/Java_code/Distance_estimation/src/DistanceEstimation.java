public class DistanceEstimation {
	public DistanceEstimation() {
		
	}
	
	public double set_distance(double cx, double cy, double z0x, 
			double z0y) {
		Complex z_new;
		Complex dz_new;
		Complex c = new Complex(cx,cy);
		Complex z = new Complex(z0x, z0y);
		Complex dz = new Complex(1, 0);
		int cnt = 1;
		while (cnt < 10) {
			z_new = z.times(z).plus(c);
			dz_new = new Complex(2, 0).times(z).times(dz);
			z = z_new;
			dz = dz_new;
			if (z.abs() > 1) {
				break;
			}
			cnt++;
		}
		return z.abs() * Math.log(z.abs()) / dz.abs();
	}
}
