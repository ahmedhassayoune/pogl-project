#iChannel0 "self"

#define alive vec4(1.0,1.0,1.0,1.0)
#define dead vec4(0.0,0.0,0.0,1.0)
#define id(val) vec4(val, val, val, 1.0)

int gen_nb_frames = 1;

// Random function generator from https://www.shadertoy.com/view/Nsf3Ws
//////////////////////////////////////////////////////////////////////
uint seed = 0u;
void hash(){
    seed ^= 2747636419u;
    seed *= 2654435769u;
    seed ^= seed >> 16;
    seed *= 2654435769u;
    seed ^= seed >> 16;
    seed *= 2654435769u;
}

void initRandomGenerator(){
    seed = uint(gl_FragCoord.y*iResolution.x + gl_FragCoord.x)+uint(iFrame)*uint(iResolution.x)*uint(iResolution.y);
}

float random(){
    hash();
    return float(seed)/4294967295.0;
}
/////////////////////////////////////////////////////////////////////

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
    initRandomGenerator();
    vec2 size = iResolution.xy;
    vec2 uv = gl_FragCoord.xy / size;
    
    int x = int(gl_FragCoord.x);
    int y = int(gl_FragCoord.y);
    
    int frame = iFrame / gen_nb_frames;
    if (frame < 1)
    {
        gl_FragColor = dead;
        if (y == 0)
        {
            float rand = random();
            if (rand > 0.5)
            {
                gl_FragColor = alive;
            }
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
            if (val + left + right < 0.5)
            {
                gl_FragColor = dead;
            }
            else if (val > 0.5 && right < 0.5 && left > 0.5)
            {
                gl_FragColor = dead;
            }
            else if (val > 0.5 && right < 0.5 && left < 0.5)
            {
                gl_FragColor = dead;
            }
            else if (val < 0.5 && right > 0.5 && left < 0.5)
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