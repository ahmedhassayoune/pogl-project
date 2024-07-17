float scale = 2.0;
int gen_nb_frames = 2;

#define healthy vec4(0.0, 0.0, 0.0, 1.0)
#define ill vec4(q, q, q, 1.0)
#define id(val) vec4(val, val, val, 1.0)

#define brush_radius 40.0

#define q 200.0
// integer in the range [2, 255]

#define k1 2.0
// 2 or 3 for best results
#define k2 3.0
// 3 for best results

#define g 70.0
// integer in the range [0,100]