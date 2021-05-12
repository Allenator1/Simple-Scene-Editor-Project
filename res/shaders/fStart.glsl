varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 Lvec1;
varying vec3 E;
varying vec3 N;

uniform sampler2D texture;
uniform vec3 DiffuseProduct1, SpecularProduct1, AmbientProduct1;
uniform vec3 DiffuseProduct2, SpecularProduct2, AmbientProduct2;
uniform vec4 LightPosition2;
uniform float Shininess;

void generateLight(inout vec3 lightComponents[3], vec3 Lvec, vec3 ambientProduct, 
    vec3 diffuseProduct, vec3 specularProduct, float b, float c);

void main()
{   
    vec3 Lvec2 = LightPosition2.xyz;     // Inverse direction of light source 2

    vec3 light1Components[3];   // Components for point light source
    generateLight(light1Components, Lvec1, AmbientProduct1, 
        DiffuseProduct1, SpecularProduct1, 0.7, 1.8);

    vec3 light2Components[3];   // Components for directional light source
    generateLight(light2Components, Lvec2, AmbientProduct2, 
        DiffuseProduct2, SpecularProduct2, 0.22, 0.2);

    vec3 globalAmbient = vec3(0.15, 0.15, 0.15);

    vec4 color;
    color.rgb += globalAmbient;

    color.rgb += light1Components[0] + light1Components[1] + light1Components[2];
    color.rgb += light2Components[0] + light2Components[1] + light2Components[2];

    color.a = 1.0; 

    gl_FragColor = color * texture2D( texture, texCoord * 2.0 );
}


void generateLight(inout vec3 lightComponents[3], vec3 Lvec, vec3 ambientProduct, 
    vec3 diffuseProduct, vec3 specularProduct, float b, float c) {

    float dist_attun = 1.0 / (1.0 + b * length(Lvec) + c * pow(length(Lvec), 2.0));
    vec3 L = normalize(Lvec);     
    vec3 H = normalize(L + E);

    vec3 ambient = ambientProduct * dist_attun;
    lightComponents[0] = ambient;

    float Kd = max( dot(L, N), 0.0 ) * dist_attun;
    vec3 diffuse = Kd * diffuseProduct;
    lightComponents[1] = diffuse;

    float Ks = pow( max(dot(N, H), 0.0), Shininess ) * dist_attun;
    vec3 specular = Ks * specularProduct;
    if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 
    lightComponents[2] = specular;
}


