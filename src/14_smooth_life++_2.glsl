#include "14_smooth_life++_utils.glsl"

#iChannel0 "file://14_smooth_life++_1.glsl"

vec2 integrate_x(vec2 uv) {
    float inner_sum = 0.0, annulus_sum = 0.0, inner_w_sum = 0.0, annulus_w_sum = 0.0;

    // Compute center pixel
    float val = texture(iChannel0, uv).r;
    inner_sum += val;
    inner_w_sum += 1.0;

    // Apply x-pass symmetrically
    for (int i = 1; i <= KERNEL_RADIUS; i++) {
        vec2 pos = vec2(i, 0.0);
        float d = length(pos);
        if (d > (OUTER_RADIUS + 0.5)) {
            continue;
        }

        vec2 dpos = pos / iResolution.xy;

        if (d <= (INNER_RADIUS + 0.5)) {
            float val = texture(iChannel0, fract(uv + dpos)).x;
            float val_opp = texture(iChannel0, fract(uv - dpos)).x;
            float w = smooth_edge(d, INNER_RADIUS);
            inner_sum += w * (val + val_opp);
            inner_w_sum += 2.0 * w;
        }

        if (d >= (INNER_RADIUS - 0.5) && d <= (OUTER_RADIUS + 0.5)) {
            float val = texture(iChannel0, fract(uv + dpos)).y;
            float val_opp = texture(iChannel0, fract(uv - dpos)).y;
            float w = smooth_edge(d, OUTER_RADIUS);
            annulus_sum += w * (val + val_opp);
            annulus_w_sum += 2.0 * w;
        }
    }

    return vec2(inner_sum / inner_w_sum, annulus_sum / annulus_w_sum);
}

void main() {
    vec2 size = iResolution.xy;
    vec2 uv = gl_FragCoord.xy / size;

    vec2 x_pass = integrate_x(uv);

    gl_FragColor = vec4(x_pass, 0.0, 1.0);
}