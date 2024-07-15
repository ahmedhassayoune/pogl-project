#iChannel0 "self"

#define alive vec4(1.0,1.0,1.0,1.0)
#define dead vec4(0.0,0.0,0.0,1.0)
#define id(val) vec4(val, val, val, 1.0)

int gen_nb_frames = 1;

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
    
    int x = int(gl_FragCoord.x);
    int y = int(gl_FragCoord.y);
    
    int frame = iFrame / gen_nb_frames;
    if (frame < 1)
    {
        if (y == 0 && x == 400)
        {
            gl_FragColor = alive;
        }
        else
        {
            gl_FragColor = dead;
        }
    }
    else
    {  
        if (y < frame)
        {
            float val = texture(iChannel0, uv).r;
            gl_FragColor = id(val);
        }
        else if (y == frame)
        {
            float val = sample_tex(uv, 0.0, -1.0);
            float left = sample_tex(uv, -1.0, -1.0);
            float right = sample_tex(uv, 1.0, -1.0);
            
            gl_FragColor = alive;
            if (val + left + right > 2.5)
            {
                gl_FragColor = dead;
            }
            else if (val + left + right < 0.5)
            {
                gl_FragColor = dead;
            }
            else if (val < 0.5 && right > 0.5 && left > 0.5)
            {
                gl_FragColor = dead;
            }
            else if (val > 0.5 && right < 0.5 && left < 0.5)
            {
                gl_FragColor = dead;
            }
        }
        else
        {
            gl_FragColor = dead;
        }
    }
}