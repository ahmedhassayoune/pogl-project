#iChannel0 "self"
#iChannel2 "file://../assets/pebbles.png"

#define alive vec4(1.0,1.0,1.0,1.0)
#define dead vec4(0.0,0.0,0.0,1.0)
#define id(val) vec4(val, val, val, 1.0)

#define brush_radius 10.0
#define gen_nb_frames 1
#define scale 1.0

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

void main(void)
{
    vec2 size = iResolution.xy;
    
    vec2 uv = gl_FragCoord.xy / size;
    
    vec4 val = dead;
    
    if (iFrame == 0)
    {
        val = texture(iChannel2, uv);
        gl_FragColor = val;
    }
    else
    {
        val = texture(iChannel0, uv);
        
        int frame = iFrame % gen_nb_frames;
        if (frame == 0)
        {
            float around =  
                  sample_tex(uv, -1.0, 0.0)
                + sample_tex(uv, -1.0, 1.0)
                + sample_tex(uv, 0.0, 1.0)
                + sample_tex(uv, 1.0, 1.0)
                + sample_tex(uv, 1.0, 0.0)
                + sample_tex(uv, 1.0, -1.0)
                + sample_tex(uv, 0.0, -1.0)
                + sample_tex(uv, -1.0, -1.0);

            if (around > 2.9 && around < 3.1)
            {
                gl_FragColor = alive;
            }
            else if (around < 2.0 || around > 3.0)
            {
                gl_FragColor = dead;
            }
            else
            {
                gl_FragColor = val;
                gl_FragColor -= vec4(0.0, 0.01, 0.01, 0.0);
            }
        }
        else
        {
            gl_FragColor = val;
        }
    }
    
    float d = length(iMouse.xy - gl_FragCoord.xy);
    if (iMouse.z > 0.0 && d < brush_radius)
    {
        gl_FragColor = alive;
    }
}
