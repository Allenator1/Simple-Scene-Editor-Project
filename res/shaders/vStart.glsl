attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec3 Lvec1;
varying vec3 E;
varying vec3 N;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition1;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;

    // The vector to the light from the vertex    
    Lvec1 = LightPosition1.xyz - pos;

    // Direction to the eye/camera 
    E = normalize( -pos );     
    // Normal vector transformed to eye coordinates                             
    N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
