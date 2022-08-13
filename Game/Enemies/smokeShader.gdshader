shader_type canvas_item;

uniform sampler2D texture1;
uniform float tex1Boost = 0.0;
uniform sampler2D texture2;
uniform float tex2Boost = 0.0;

uniform vec2 scorll1 = vec2(0.25,-0.3);
uniform vec2 scorll2 = vec2(0.2,-0.4);

uniform sampler2D lifetimeGradient;
uniform sampler2D overlapGradient;

uniform float sharpnes = 5.0;

void fragment(){
	
	float particleSeed = COLOR.r / (COLOR.r + COLOR.b + COLOR.g);
	
	float adjustedTime = TIME + particleSeed * 154.685;
	
	float intesity = (texture(texture1, UV + scorll1 * adjustedTime).r + tex1Boost) * (texture(texture2, UV + scorll2 * adjustedTime).r + tex2Boost);
	
	vec4 overlapColor = texture(overlapGradient, vec2(intesity * 2.8));
	
	vec4 lifetimeColor = texture(lifetimeGradient, vec2(COLOR.a));
	COLOR = lifetimeColor * overlapColor;
	COLOR.a *= min(1.0, intesity * sharpnes) * texture(TEXTURE,UV).a;
}