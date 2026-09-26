shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture;

uniform float temperatureRange : hint_range(-1.0, 1.0) = 0;
uniform vec4 hotColor : source_color;
uniform vec4 coldColor : source_color;

uniform float heatAmplitude : hint_range(0.0, 0.15);
uniform float heatPeriod;
uniform float heatPhaseShift;
uniform float heatUpperLimit : hint_range(0.0, 10.0);
uniform float coldFractureCount = 10.0;

// edge feather parameters
uniform float divide = 0.065;      
uniform float blur = 0.385;        
uniform float fade_width = 0.995;


void fragment() {
	
	float currentHot = clamp(temperatureRange,0.0,1.0);
	float currentCold = -clamp(temperatureRange,-1.0,0.0);
	vec4 hotnessColor = (hotColor * currentHot);
	vec4 coldnessColor = (coldColor * currentCold);
	
	vec2 modifiedUVHot = SCREEN_UV;
	vec2 modifiedUVCold = SCREEN_UV;
	
	//Cold Effect
	modifiedUVCold.x -= (fract(modifiedUVHot.y*(coldFractureCount*currentCold)))*currentCold*0.01;
	modifiedUVCold.y -= ((-fract(modifiedUVHot.x*(coldFractureCount*currentCold)))*0.8)*currentCold*0.01;
	modifiedUVHot.x -= (((1.0 - modifiedUVHot.y)*heatAmplitude)*sin(heatPeriod*(modifiedUVHot.y-(TIME*0.016*heatPhaseShift))))
	*clamp(1.0-(modifiedUVHot.y*(10.0-heatUpperLimit)),0.0,0.5)*currentHot;
	
	//Hot effect
	modifiedUVHot.y -= (((1.0 - modifiedUVHot.x)*heatAmplitude)*sin(heatPeriod*(modifiedUVHot.x-(TIME*0.012*heatPhaseShift))))
	*clamp(1.0-(modifiedUVHot.x*(10.0-heatUpperLimit)),0.0,0.5)*currentHot;
	
	//heat and cold distortion
	COLOR = texture(screen_texture,(modifiedUVHot+modifiedUVCold)*0.5);
	COLOR.rgb += hotnessColor.rgb * hotnessColor.a;
	COLOR.rgb += coldnessColor.rgb * coldnessColor.a;
	
	//edge fades and waves
	float left_fade_edge = fade_width;
    float right_fade_edge = 1.0 - fade_width;
    float leftFade = 1.0;
    float rightFade = 1.0;
	
	float lower_fade_edge = fade_width;
    float upper_fade_edge = 1.0 - fade_width;
    float lowerFade = 1.0;
    float upperFade = 1.0;

    //Left/right
    if (UV.x < left_fade_edge) {
        float px = UV.x / fade_width;
        leftFade = smoothstep(divide, divide + blur, px);
    }
    if (UV.x > right_fade_edge) {
        float px = (1.0 - UV.x) / fade_width;
        rightFade = smoothstep(divide, divide + blur, px);
    }
	//up/down
	 if (UV.y < lower_fade_edge) {
        float px = UV.y / fade_width;
        lowerFade = smoothstep(divide, divide + blur, px);
    }
    if (UV.y > upper_fade_edge) {
        float px = (1.0 - UV.y) / fade_width; // mirrored
        upperFade = smoothstep(divide, divide + blur, px);
    }
	
	
	
	//applying alpha
	COLOR.a *= (min(leftFade, rightFade)*min(lowerFade, upperFade));
	//COLOR.a *= ((fract((UV.x+TIME)*2.0)*fract(-(UV.x+TIME)*2.0))*5.0);
}