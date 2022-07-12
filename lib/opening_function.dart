import 'dart:math';

double initCooling(double oat, double ewt, double compSpd) {
  return 0.67556008 * compSpd +
      0.56800173 * ewt +
      0.15263822 * oat +
      0.0000074486943 * compSpd * oat * oat +
      0.0002901458 * ewt * oat * oat -
      0.0048552186 * oat * oat -
      0.000125714 * pow(oat, 3) -
      0.0049247155 * compSpd * ewt -
      0.00056611915 * compSpd * oat +
      0.0030657933 * ewt * oat -
      0.00008931248 * compSpd * ewt * oat +
      20.432458;
}
