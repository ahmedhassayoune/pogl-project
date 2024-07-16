#include "05_viral_replication_utils.glsl"

#iChannel0 "file://05_viral_replication_2.glsl"

void main(void)
{
    float cell_state = texture(iChannel0, gl_FragCoord.xy/(iResolution.xy * scale)).r;
    
    if (cell_state > (q - 0.5))
    {
        gl_FragColor = white;
    }
    else if (cell_state > 1.5)
    {
        float val = cell_state / q;
        gl_FragColor = mix(white, black, val);
    }
    else if (cell_state > 0.5)
    {
        gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    }
    else
    {
        gl_FragColor = black;
    }
}
