#iChannel0 "self"
#iChannel2 "file://../assets/noise.png"


#define alive vec4(1.0,1.0,1.0,1.0)
#define dead vec4(0.0,0.0,0.0,1.0)
#define id(val) vec4(val, val, val, 1.0)

#define brush_radius 10.0

float dist(vec2 p0, vec2 p1) {
    return sqrt(pow(p0.x - p1.x, 2.0) + pow(p0.y - p1.y, 2.0));
}

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
    
    float val = 0.0;
    if (iFrame == 0)
    {
        val = texture(iChannel2, uv).r;
        gl_FragColor = id(val);
    }
    else
    {
        val = sample_tex(uv, 0.0, 0.0);
        
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
            gl_FragColor = id(val);
        }
    }
    
    if (iMouse.z > 0.0 && dist(iMouse.xy, gl_FragCoord.xy) < brush_radius)
    {
        gl_FragColor = alive;
    }
}