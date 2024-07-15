// Global variables and utils

float scale = 1.0;
int gen_nb_frames = 1;

#define healthy vec4(q, q, q, 1.0)
#define dead vec4(0.0, 0.0, 0.0, 1.0)
#define id(val) vec4(val, val, val, 1.0)

#define brush_radius 40.0

#define white vec4(1.0, 1.0, 1.0, 1.0)
#define black vec4(0.0, 0.0, 0.0, 1.0)

// Viral Replication variables

#define q 7.0

#define base_rate 0.000002

#define active_rate 0.6

#define cell_div_rate 0.1

float dist(vec2 p0, vec2 p1) {
    return sqrt(pow(p0.x - p1.x, 2.0) + pow(p0.y - p1.y, 2.0));
}