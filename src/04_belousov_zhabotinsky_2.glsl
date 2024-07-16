#include "04_belousov_zhabotinsky_utils.glsl"

#iChannel0 "self"
#iChannel2 "file://../assets/noise-small.png"


float sample_tex(vec2 uv, float i, float j)
{
    vec2 delta_ij = vec2(i,j) / iResolution.xy;
    float val = texture(iChannel0, uv + delta_ij).r;
    if (val > 0.0)
    {
        return val;
    }
    return 0.0;
}

vec3 count_neighbours(vec2 uv)
{
    vec3 count = vec3(0.0, 0.0, 0.0);
    for (int i=-1; i <= 1; i += 1)
    {
        for (int j=-1; j <= 1; j += 1)
        {
            float val = sample_tex(uv, float(i), float(j));
            if ((i != 0) || (j != 0))
            {
                if (val > 0.5)
                {
                    if (val > (q - 0.5))
                    {
                        count = count + vec3(0.0, 1.0, 0.0);
                    }
                    else
                    {
                        count = count + vec3(1.0, 0.0, 0.0);
                    }
                }
            }
            count = count + vec3(0.0, 0.0, val);
        }
    }
    return count;
}

void main(void)
{
    vec2 size = iResolution.xy;
    
    vec2 uv = gl_FragCoord.xy / size;
    
    if (iFrame == 0)
    {
        float factor = texture(iChannel2, uv).r;
        gl_FragColor = factor * ill;
    }
    else
    {
        vec4 val = texture(iChannel0, uv);
        
        int frame = iFrame % gen_nb_frames;
        if (frame == 0)
        {
            vec3 neighbours = count_neighbours(uv);
            float a = neighbours[0];
            float b = neighbours[1];
            float s = neighbours[2];

            float cell = val.r;
            
            if (cell < 0.5) // Current cell is healthy
            {
                gl_FragColor = id(float(int(a / k1) + int(b / k2)));
            }
            else if (cell < (q - 0.5)) // Current cell is infected
            {
                gl_FragColor = id(float(int(s/(a + b + 1.0))) + g);
            }
            else // Current cell is ill
            {
                gl_FragColor = healthy;
            }
        }
        else
        {
            gl_FragColor = val;
        }
    }
    
    if (iMouse.z > 0.0 && distance(iMouse.xy, gl_FragCoord.xy * scale) < brush_radius)
    {
        gl_FragColor = healthy;
    }
}