#iChannel0 "self"
#iChannel2 "file://../assets/noise.png"

#define id(val) vec4(val, val, val, 1.0)

const int KERNEL_SIZE = 23;

const float INNER_RADIUS = 7.0;
const float OUTER_RADIUS = 3.0 * INNER_RADIUS;

const float B1 = 0.278;
const float B2 = 0.365;

const float D1 = 0.267;
const float D2 = 0.445;

const float ALPHA_N = 0.028;
const float ALPHA_M = 0.147;

float dist(vec2 p0, vec2 p1) {
    return sqrt(pow(p0.x - p1.x, 2.0) + pow(p0.y - p1.y, 2.0));
}

float sigma(float x, float a, float alpha) {
    return 1.0 / (1.0 + exp(-4.0 * (x - a) / alpha));
}

float smooth_edge(float x, float cutoff) {
    return 1.0 - sigma(x, cutoff, 0.5);
}

float sigma_m(float m, float x, float y) {
    float w = sigma(m, 0.5, ALPHA_M);
    return x * (1.0 - w) + y * w;
}

float sigma_n(float x, float a, float b) {
    return sigma(x, a, ALPHA_N) * (1.0 - sigma(x, b, ALPHA_N));
}

float S(float m, float n) {
    return sigma_n(
        n,
        sigma_m(m, B1, D1),
        sigma_m(m, B2, D2)
    );
}

vec2 integrate(vec2 uv) {
    float inner_sum = 0.0, annulus_sum = 0.0, inner_w_sum = 0.0, annulus_w_sum = 0.0;
    for (int i = -KERNEL_SIZE; i <= KERNEL_SIZE; i++) {
        for (int j = -KERNEL_SIZE; j <= KERNEL_SIZE; j++) {

            float d = sqrt(float(i*i + j*j));
            if (d > (OUTER_RADIUS + 0.5)) {
                continue;
            }

            vec2 current_uv = fract(uv + vec2(i, j) / iResolution.xy);
            float val = texture(iChannel0, current_uv).r;

            if (d <= (INNER_RADIUS + 0.5)) {
                float w = smooth_edge(d, INNER_RADIUS);
                inner_sum += val * w;
                inner_w_sum += w;
            }

            if (d >= (INNER_RADIUS - 0.5) && d <= (OUTER_RADIUS + 0.5)) {
                float w = smooth_edge(d, OUTER_RADIUS);
                annulus_sum += val * w;
                annulus_w_sum += w;
            }
        }
    }

    return vec2(inner_sum / inner_w_sum, annulus_sum / annulus_w_sum);
}

void main(void) {
    vec2 size = iResolution.xy;
    vec2 uv = gl_FragCoord.xy / size;

    if (iFrame == 0) {
        float val = texture(iChannel2, uv).r;
        gl_FragColor = id(val);
    }
    else {
        vec2 mn = integrate(uv);
        gl_FragColor = vec4(S(mn.x, mn.y), mn.x, mn.y, 1.0);
    }

}