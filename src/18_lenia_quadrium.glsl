#iChannel0 "self"
#iChannel2 "file://../assets/pebbles.png"

#define id(val) vec4(val, val, val, 1.0)

const float PI = 3.14159265358979;
const int KERNEL_RADIUS = 20;
const float dt = 0.2;
const float EPS = 1e-5;
const vec4 beta = vec4(1.0, 2.0/3.0, 1.0/3.0, 2.0/3.0);

float sigmoid(float x, float a, float alpha) {
    return 1.0 / (1.0 + exp(-4.0 * (x - a) / alpha));
}

float kernel_core(float r) {
    const float alpha = 1.0;

    float k = 4.0 * r * (1.0 - r);
    if (k < EPS) {
        return 0.0;
    }
    return exp(alpha * (1.0 - 1.0 / k));
}

float kernel_layer(vec2 pos) {
    float r = length(pos) / float(KERNEL_RADIUS);
    if (r <= 0.25) return beta[0] * kernel_core(4.0 * r);
    if (r <= 0.5) return beta[1] * kernel_core(4.0 * r - 1.0);
    if (r <= 0.75) return beta[2] * kernel_core(4.0 * r - 2.0);
    return beta[3] * kernel_core(4.0 * r - 3.0);
}

float delta(float n) {
    const float mu = 0.16;
    const float sigma = 0.01;

    float l = abs(n - mu);
    float k = 2.0 * sigma * sigma;
    return 2.0 * exp(- l * l / k) - 1.0;
}

float field_transition(float n) {
    return delta(n) * dt;
}

float integrate(vec2 uv) {
    float sum = 0.0, w_sum = 0.0;
    for (int i = -KERNEL_RADIUS; i <= KERNEL_RADIUS; i++) {
        for (int j = -KERNEL_RADIUS; j <= KERNEL_RADIUS; j++) {
            vec2 dpos = vec2(i, j);
            vec2 current_uv = fract(uv + dpos / iResolution.xy);

            float val = texture(iChannel0, current_uv).r;
            float w = kernel_layer(dpos);

            sum += val * w;
            w_sum += w;
        }
    }

    return sum / w_sum;
}

void main(void) {
    vec2 size = iResolution.xy;
    vec2 uv = gl_FragCoord.xy / size;

    if (iFrame < 10) {
        float val = texture(iChannel2, uv).r;
        gl_FragColor = id(val);
        return;
    }

    float old_val = texture(iChannel0, uv).r;

    float n = integrate(uv);
    float new_val = old_val + field_transition(n);
    vec4 color = id(new_val);
    color = clamp(color, 0.0, 1.0);

    if(iMouse.z > 0.0) {
        float d = length(gl_FragCoord.xy - iMouse.xy);
        if(d <= float(KERNEL_RADIUS)) {
            float val = texture(iChannel2, uv).r;
            color = id(val);
        }
    }

    gl_FragColor = color;
}