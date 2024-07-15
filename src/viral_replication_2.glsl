#include "viral_replication_utils.glsl"

#iChannel0 "self"
#iChannel2 "file://../assets/noise.png"

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

// Function to generate a float with a Gaussian distribution centered at 1
float generateGaussian(float u1, float u2) {
    // Box-Muller method to generate two Gaussian numbers
    float radius = sqrt(-2.0 * log(u1));
    float theta = 2.0 * 3.141592653589793 * u2;
    float z0 = radius * cos(theta);
    float z1 = radius * sin(theta);

    // Adjust to center at 1
    float result = 0.5 * z0 + 1.0;

    return result;
}

// Function to generate the degeneration factor of the cell (between 0.0 and 2.0)
float get_random_degeneration()
{
    float u1 = random();
    float u2 = random();
    float x = generateGaussian(u1, u2);
    x = clamp(x, 0.0, 2.0);
    return x;
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

vec2 count_neighbours(vec2 uv)
{
    vec2 count = vec2(0.0, 0.0);
    for (int i=-1; i <= 1; i += 1)
    {
        for (int j=-1; j <= 1; j += 1)
        {
            if ((i != 0) || (j != 0))
            {
                float val = sample_tex(uv, float(i), float(j));
                if (val > (q - 0.5)) // Healthy neighbour cell
                {
                    count = count + vec2(1.0, 0.0);
                }
                else if ((val > 0.5) && (val < 1.5)) // Dying neighbour cell
                {
                    count = count + vec2(0.0, 1.0);
                }
            }
        }
    }
    return count;
}

void main(void)
{
    initRandomGenerator();
    
    vec2 size = iResolution.xy;
    vec2 uv = gl_FragCoord.xy / size;
    
    if (iFrame == 0)
    {
        gl_FragColor = dead;
    }
    else
    {
        vec4 val = texture(iChannel0, uv);
        
        int frame = iFrame % gen_nb_frames;
        if (frame == 0)
        {
            float cell = val.r;
            
            if (cell > (q - 0.5)) // Current cell is healthy
            {
                if (random() < base_rate) // Small chance that the cell becomes initially infected
                {
                    // Starts the degeneration
                    gl_FragColor = id(cell - get_random_degeneration());
                }
                else
                {
                    // Count the number of dying cells in the neighbours
                    int nb_dying_neighbours = int(count_neighbours(uv)[1]);
                    // The probability that at least one dying neighbours will infect the current cell
                    float prob = 1.0 - pow((1.0 - active_rate), float(nb_dying_neighbours));
                    if (random() < prob) // The current cell becomes infected
                    {
                        // Starts the degeneration
                        gl_FragColor = id(cell - get_random_degeneration());
                    }
                    else // The current cell stays healthy
                    {
                        gl_FragColor = healthy;
                    }
                }
            }
            else if ((cell < (q - 0.5)) && (cell > 0.5)) // Current cell is infected
            {
                // Continue the degeneration
                gl_FragColor = id(cell - get_random_degeneration());
            }
            else // Current cell is dead
            {
                // Count the number of living cells in the neighbours
                int nb_neighbours = int(count_neighbours(uv)[0]);
                // The probability that at least one of these neighbouring cells will replicate on the current cell
                float prob = 1.0 - pow((1.0 - cell_div_rate), float(nb_neighbours));
                if (random() < prob)
                {
                    // Replication of a neighbouring cell
                    gl_FragColor = healthy;
                }
                else
                {
                    // Nothing changes, the cell is still dead
                    gl_FragColor = dead;
                }
            }
        }
        else
        {
            gl_FragColor = val;
        }
    }
    
    if (iMouse.z > 0.0 && dist(iMouse.xy, gl_FragCoord.xy * scale) < brush_radius)
    {
        // Create healthy cells with the mouse click
        gl_FragColor = healthy;
    }
}