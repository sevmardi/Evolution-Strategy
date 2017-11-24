
#include "matrix.h"
#include <cmath> 
#include <math.h>
#include <iostream>
#include <iterator>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

#ifndef M_PI
	#define M_PI 3.14159265358979323846
#endif	

using namespace std;

// eta: 0 = Ge (4.2), 1 = Zn (2.2)
double optical_filter(Vector const& d, Vector const& eta)
{
	const unsigned int layers = d.size();
	constexpr int m = 47;
	constexpr double XAir = 1.0;
	constexpr double XSub = 4.0;
	constexpr double lower = 7.7;

	constexpr double stepsize = 1000.0 * (12.3 - lower) / (m - 1);
	constexpr double ConsI = XAir * XSub * 4.0;

	double Y11, Y12, Y21, Y22;
	double refl = 0.0;

	for (unsigned int i=1; i<=m; i++)
	{
		const double lambda = lower * 1000.0 + stepsize * (i - 1.0);

		Y11 = Y22 = 1.0;
		Y12 = Y21 = 0.0;

		for (unsigned int j=1; j<=layers; j++)
		{
			const double ref = (eta[j-1]) ? 2.2 : 4.2; // refractive index
			const double delta = 2.0 * M_PI * d[j-1] * ref / lambda;

			const double X11 = std::cos(delta);
			const double X22 = X11;
			const double AA = std::sin(delta);

			const double X21 = AA * ref;
			const double X12 = AA / ref;

			const double Z11 =  Y11 * X11 - Y12 * X21;
			const double Z12 =  Y11 * X12 + Y12 * X22;
			const double Z21 =  Y21 * X11 + Y22 * X21;
			const double Z22 = -Y21 * X12 + Y22 * X22;

			Y11 = Z11;
			Y12 = Z12;
			Y21 = Z21;
			Y22 = Z22;
		}

		const double QQ1 = XAir * Y11 + XSub * Y22;
		const double QQ2 = XAir * XSub * Y12 + Y21;
		refl = refl + pow((1.0 - ConsI / (QQ1 * QQ1 + QQ2 * QQ2)), 2);

	}
	return sqrt(refl / m);
}

int main(int argc, char** argv) 
{
	if (argc != 31) {
		std::cerr << "Wrong number of inputs!\n";
		return -1;
    }

	Vector d = Vector(30, 0.0);
	for (int i = 0; i < 30; i++) {
		d[i] = std::atof(argv[i + 1]);
	}

	const Vector eta {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1};
	double res = optical_filter(d, eta);
    cout.precision(15);
    cout << res;

	return res;
}
