#iChannel0 "self"
#iChannel2 "file://../assets/pebbles.png"

#define id(val) vec4(val, val, val, 1.0)

const float PI = 3.14159265358979;

const float INNER_RADIUS = 5.0;
const float OUTER_RADIUS = 3.0 * INNER_RADIUS;

const int KERNEL_SIZE = int(OUTER_RADIUS);

const float INNER_AREA = PI * INNER_RADIUS * INNER_RADIUS;
const float ANNULUS_AREA = PI * (OUTER_RADIUS * OUTER_RADIUS - INNER_RADIUS * INNER_RADIUS);

const float B1 = 0.278;
const float B2 = 0.365;

const float D1 = 0.267;
const float D2 = 0.445;

const float ALPHA_N = 0.028;
const float ALPHA_M = 0.147;

const float dt = 0.3;

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
    float inner_sum = 0.0, annulus_sum = 0.0;
    for (int i = -KERNEL_SIZE; i <= KERNEL_SIZE; i++) {
        for (int j = -KERNEL_SIZE; j <= KERNEL_SIZE; j++) {

            float d = length(vec2(i, j));
            if (d > (OUTER_RADIUS + 0.5)) {
                continue;
            }

            vec2 current_uv = fract(uv + vec2(i, j) / iResolution.xy);
            float val = texture(iChannel0, current_uv).r;

            if (d <= (INNER_RADIUS + 0.5)) {
                float w = smooth_edge(d, INNER_RADIUS);
                inner_sum += val * w;
            }

            if (d >= (INNER_RADIUS - 0.5) && d <= (OUTER_RADIUS + 0.5)) {
                float w = smooth_edge(d, OUTER_RADIUS);
                annulus_sum += val * w;
            }
        }
    }

    return vec2(inner_sum / INNER_AREA, annulus_sum / ANNULUS_AREA);
}

void main(void) {
    vec2 size = iResolution.xy;
    vec2 uv = gl_FragCoord.xy / size;

    if (iFrame == 0) {
        float val = texture(iChannel2, uv).r;
        gl_FragColor = id(val);
        return;
    }

    vec3 color;
    color = texture(iChannel0, uv).rgb;
    vec2 mn = integrate(uv);
    float s = S(mn.x, mn.y);
    color.r = color.r + dt * (2.0 * s - 1.0);
    color.gb = mn;
    color = clamp(color, 0.0, 1.0);

    if(iMouse.z > 0.0) {
        float d = length(gl_FragCoord.xy - iMouse.xy);
        if(d <= OUTER_RADIUS) {
            color.x = sigma(d, INNER_RADIUS, 0.5);
        }
    }

    gl_FragColor = vec4(color.rgb, 1.0);
}