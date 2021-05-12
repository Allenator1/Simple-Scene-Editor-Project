varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 Lvec1;
varying vec3 H1;
varying vec3 E;
varying vec3 norm;
varying vec3 ambient;

uniform sampler2D texture;
uniform vec3 DiffuseProduct1, SpecularProduct1, AmbientProduct1;
uniform vec3 DiffuseProduct2, SpecularProduct2, AmbientProduct2;
uniform vec4 LightPosition2;
uniform float Shininess;

void generateLight(inout vec3 lightComponents[3], vec3 Lvec, vec3 H, vec3 N, vec3 ambientProduct, vec3 diffuseProduct, vec3 specularProduct);

void main()
{   
    vec3 Lvec2 = LightPosition2.xyz;     // Inverse direction of directional light source
    vec3 H2 = normalize(normalize(Lvec2) + E);     // Halfway vector for light 2

    vec3 light1Components[3];
    generateLight(light1Components, Lvec1, H1, norm, 
        AmbientProduct1, DiffuseProduct1, SpecularProduct1);

    vec3 light2Components[3];
    generateLight(light2Components, Lvec2, H2, norm, 
        AmbientProduct2, DiffuseProduct2, SpecularProduct2);

    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    vec4 color;
    color.rgb += globalAmbient;

    color.rgb += light1Components[0] + light1Components[1] + light1Components[2];
    color.rgb += light2Components[0] + light2Components[1] + light2Components[2];

    color.a = 1.0; 

    gl_FragColor = color * texture2D( texture, texCoord * 2.0 );
}


void generateLight(inout vec3 lightComponents[3], vec3 Lvec, vec3 H, vec3 N, vec3 ambientProduct, vec3 diffuseProduct, vec3 specularProduct) {

    float a = 1.0;              // constant term
    float b = 0.7;              // linear term
    float c = 1.8;              // quadratic term

    float dist_attun = 1.0 / (a + b * length(Lvec) + c * pow(length(Lvec), 2.0));
    vec3 L = normalize(Lvec);     // Direction to light source 1
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


