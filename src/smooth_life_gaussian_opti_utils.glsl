#define id(val) vec4(val, val, val, 1.0)

const float PI = 3.14159265358979;

const float INNER_RADIUS = 4.0;
const float OUTER_RADIUS = 3.0 * INNER_RADIUS;
const int KERNEL_SIZE = 50;

const float B1 = 0.257;
const float B2 = 0.335;

const float D1 = 0.358;
const float D2 = 0.552;

const float ALPHA_N = 0.028;
const float ALPHA_M = 0.147;

const float dt = 0.08;

float gaussian(float x, float coef, float sigma) {
    return coef * exp(-0.5 * x * x / (sigma * sigma));
}
