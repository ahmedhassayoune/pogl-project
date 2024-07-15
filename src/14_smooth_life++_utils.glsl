#define id(val) vec4(val, val, val, 1.0)

const float PI = 3.14159265358979;

const float INNER_RADIUS = 5.0;
const float OUTER_RADIUS = 3.0 * INNER_RADIUS;

const int KERNEL_RADIUS = int(OUTER_RADIUS);

const float B1 = 0.255;
const float B2 = 0.340;

const float D1 = 0.358;
const float D2 = 0.540;

const float ALPHA_N = 0.028;
const float ALPHA_M = 0.147;

const float dt = 0.08;

float sigmoid(float x, float a, float alpha) {
    return 1.0 / (1.0 + exp(-4.0 * (x - a) / alpha));
}

float smooth_edge(float x, float cutoff) {
    return 1.0 - sigmoid(x, cutoff, 0.5);
}
