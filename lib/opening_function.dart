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

double initHeating(double oat, double ewt, double compSpd) {
  return 1.0102612 * compSpd -
      0.23548275 * ewt +
      1.7016809 * oat -
      0.00082756589 * compSpd * pow(oat, 2) +
      0.00023077973 * ewt * pow(oat, 2) +
      0.032889717 * pow(oat, 2) -
      0.00042276831 * pow(oat, 3) -
      0.0047187125 * compSpd * ewt -
      0.0040811279 * compSpd * oat -
      0.02283985 * ewt * oat +
      0.00034302447 * compSpd * oat * ewt +
      4.5020846;
}
