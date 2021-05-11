varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 Lvec;
varying vec3 E;
varying vec3 H;
varying vec3 N;
varying vec3 ambient;

uniform sampler2D texture;
uniform vec3 DiffuseProduct, SpecularProduct, AmbientProduct;
uniform vec4 LightPosition;
uniform float Shininess;

void main()
{   
    // Calculate distance attunement

    float a = 1.0;              // constant term
    float b = 0.7;              // linear term
    float c = 1.8;              // quadratic term
    float dist = length(Lvec);
    float dist_attun = 1.0 / (a + b * dist + c * pow(dist, 2.0));

    vec3 L = normalize(Lvec);     // Direction to the light source

    // Compute terms in the illumination equation

    vec3 ambient = AmbientProduct * dist_attun;

    float Kd = max( dot(L, N), 0.0 ) * dist_attun;
    vec3 diffuse = Kd * DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess ) * dist_attun;
    vec3 specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    vec4 color;
    color.rgb = globalAmbient  + ambient + diffuse + specular;
    color.a = 1.0; 

    gl_FragColor = color * texture2D( texture, texCoord * 2.0 );
}
