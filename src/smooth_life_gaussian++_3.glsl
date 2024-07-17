#include "smooth_life_gaussian++_utils.glsl"

#iChannel0 "file://smooth_life_gaussian++_2.glsl"

vec2 integrate_y(vec2 uv) {
    float coef_inner = 1.0 / (sqrt(2.0 * PI) * INNER_RADIUS);
    float coef_outer = 1.0 / (sqrt(2.0 * PI) * OUTER_RADIUS);

    float inner_sum = 0.0, annulus_sum = 0.0, inner_w_sum = 0.0, annulus_w_sum = 0.0;

    // Compute center pixel
    float val = texture(iChannel0, uv).x;
    inner_sum += val * coef_inner;
    inner_w_sum += coef_inner;

    // Apply y-pass symmetrically
    for (int j = 1; j <= KERNEL_RADIUS; j++) {
        vec2 pos = vec2(0.0, j);
        float d = length(pos);
        if (d > (OUTER_RADIUS + 0.5)) {
            continue;
        }

        vec2 dpos = pos / iResolution.xy;

        if (d <= (INNER_RADIUS + 0.5)) {
            float val = texture(iChannel0, uv + dpos).x;
            float val_opp = texture(iChannel0, uv - dpos).x;
            float w = gaussian(float(j), coef_inner, INNER_RADIUS);
            inner_sum += w * (val + val_opp);
            inner_w_sum += 2.0 * w;
        }

        if (d >= (INNER_RADIUS - 0.5) && d <= (OUTER_RADIUS + 0.5)) {
            float val = texture(iChannel0, uv + dpos).y;
            float val_opp = texture(iChannel0, uv - dpos).y;
            float w = gaussian(float(j), coef_outer, OUTER_RADIUS);
            annulus_sum += w * (val + val_opp);
            annulus_w_sum += 2.0 * w;
        }
    }

    return vec2(inner_sum / inner_w_sum, annulus_sum / annulus_w_sum);
}

void main() {
    vec2 size = iResolution.xy;
    vec2 uv = gl_FragCoord.xy / size;

    vec2 y_pass = integrate_y(uv);

    gl_FragColor = vec4(y_pass, 0.0, 1.0);
}