
public class Poly_try {

	public static void main(String args[]) {
		Polynomial new_leja = new Polynomial(2.0, 2.0, new Complex(-1.0, -1.0), 0.1);
		new_leja.points();
		System.out.println(new_leja.all_points.toString());
		new_leja.leja(7);
		//new_leja.find_poly(7, 0.5);
	}
}
