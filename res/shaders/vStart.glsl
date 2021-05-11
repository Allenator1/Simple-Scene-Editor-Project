attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec3 Lvec;
varying vec3 E;
varying vec3 H;
varying vec3 N;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;

    // The vector to the light from the vertex    
    Lvec = LightPosition.xyz - pos;
    vec3 L = normalize(Lvec);

    // Unit direction vectors for Blinn-Phong shading calculation

    // Direction to the eye/camera 
    E = normalize( -pos );     
    // Halfway vector        
    H = normalize( L + E );    
    // Normal vector transformed to eye coordinates                             
    N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;

    /* 
    --- Compute the ambient, diffuse and specular terms in the vertex
    shader ----- 

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct * dist_attun;

    float Kd = max( dot(L, N), 0.0 ) * dist_attun;
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess ) * dist_attun;
    vec3  specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    color.rgb = globalAmbient  + ambient + diffuse + specular;
    color.a = 1.0; 
    */
}
