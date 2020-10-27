import java.util.*;

public class JuliaSet_1 {
	
	public void findDistance(int n) {
		double x;
		double y;
		double[] z_1 = new double[2];
		double[] z_2 = {0, 0};
		List<double[]> s = new ArrayList<double[]>();
		double distance;
		Random rand = new Random();
		int t = rand.nextInt(2);
		double coordinate = Math.random();
		if (t == 0) {
			z_1[0] = coordinate;
		} else {
			z_1[1] = coordinate;
		}
		s.add(z_1);
		for (int i = 1; i<= n; i++) {
			x = 0;
			y = 0;
			distance = 1;
			int size = 1;
			double max = 0;
			while (x != 1 && y != 1) {
				for (int j = 0; j < size; j++) {
					distance = distance * (Math.pow(x - s.get(j)[0], 2) + 
							Math.pow(y - s.get(j)[1], 2));
				}
				if (max < distance) {
					max = distance;
					z_2[0] = x;
					z_2[1] = y;
				}
				x+=0.1;
				y+=0.1;
			}
			size++;
			s.add(z_2);
		}
		System.out.println(s.toArray());
		System.out.println(1);
	}
}
