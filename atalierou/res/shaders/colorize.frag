#version 440
layout(location = 0) in vec2 coord;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
        float r;
         float g;
        float b;
};

layout(binding = 1) uniform sampler2D src;
void main() {
    vec4 tex = texture(src, coord);
     float avg = (tex.r + tex.g + tex.b) / 3.;
    fragColor = vec4(r * avg, g * avg, b * avg, tex.a);
}