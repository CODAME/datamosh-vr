Shader "Hidden/Twirt Effect Shader" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
    _Backbuffer("Base (RGB)", 2D) = "white" {}
}

SubShader {
	Pass {
		ZTest Always Cull Off ZWrite Off
				
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

uniform sampler2D _MainTex;
uniform sampler2D _Backbuffer;
uniform float2 resolution;
uniform float2 leftStick;
uniform float2 rightStick;

struct v2f {
	float4 pos : SV_POSITION;
	float2 uv : TEXCOORD0;
};

v2f vert( appdata_img v )
{
	v2f o;
	o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
	o.uv = v.texcoord;
	return o;
}

float3 hueShift(float3 color, float degree) {

	float3x3 rgb2yiq = float3x3(0.299, 0.595716, 0.211456, 0.587, -0.274453, -0.522591, 0.114, -0.321263, 0.311135);
	float3x3 yiq2rgb = float3x3(1.0, 1.0, 1.0, 0.9563, -0.2721, -1.1070, 0.6210, -0.6474, 1.7046);
	float3 yiq = mul(rgb2yiq, color);  // convert rgb to yiq 
	float h = (degree*0.0174532925) + atan2(yiq.g, yiq.b); // calculate new hue
	float chroma = sqrt(yiq.b * yiq.b + yiq.g * yiq.g); // convert yiq to rgb
	float3 rgb = mul(yiq2rgb, float3(yiq.r, chroma * cos(h), chroma * sin(h)));

	return rgb;
}

float4 frag (v2f i) : SV_Target
{
	/*
	float4 tex = tex2D(_MainTex, i.uv);
	float4 bb = tex2D(_Backbuffer, i.uv);

	if (tex.r > 0.5) {
		tex = bb;
	}

	return tex;
	*/

float threshold = (1.0 - abs(leftStick.y)); //0.015 //0.3
if (threshold >= 0.9) { threshold = 100000.0; }

float shift = 2.0;
float force = 20.0;
float offset = (100.0*abs(rightStick.y))+0.0; //3.0 //100.0
float lambda = 0.01;
float inverseX = -1.0;
float inverseY = -1.0;

int USE_RGB_SHIFT = 1;
int USE_HUE_SHIFT = 0;

float2 st = i.uv;

float2	off_x = float2(offset/resolution.x, 0.0);
float2	off_y = float2(0.0, offset/resolution.y);

float4	scr_dif;
float4	gradx;
float4	grady;
float4	gradmag;
float4	vx;
float4	vy;
float4	f4l = float4(lambda, lambda, lambda, lambda);
float4	flow = float4(0.0, 0.0, 0.0, 0.0);

//get the difference
scr_dif = tex2D(_MainTex, st) - tex2D(_Backbuffer, st);

//calculate the gradient
gradx = tex2D(_Backbuffer, st + off_x) - tex2D(_Backbuffer, st - off_x);
gradx += tex2D(_MainTex, st + off_x) - tex2D(_MainTex, st - off_x);
grady = tex2D(_Backbuffer, st + off_y) - tex2D(_Backbuffer, st - off_y);
grady += tex2D(_MainTex, st + off_y) - tex2D(_MainTex, st - off_y);

gradmag = sqrt((gradx*gradx) + (grady*grady) + f4l);
vx = scr_dif*(gradx/gradmag);
vy = scr_dif*(grady/gradmag);

flow.x = -(vx.x + vx.y + vx.z) / 3.0 * inverseX;
flow.y = -(vy.x + vy.y + vy.z) / 3.0 * inverseY;

flow *= float4(force, force, force, force);
flow.z = length(flow.xy);

float4 newColor = float4(1.0, 1.0, 1.0, 1.0);
float tmp = 0.3;
float4 col = tex2D(_MainTex, st);
//return scr_dif;
//return float4(flow.x, flow.y, flow.z, 1.0);

if (length(flow.xy) > threshold) {

	flow.x = clamp(flow.x, -1.0, 1.0);
	flow.y = clamp(flow.y, -1.0, 1.0);

	float2 pos = float2(0., 0.);
	pos.x = (i.uv.x*resolution.x) + flow.x;
	pos.y = (i.uv.y*resolution.y) + flow.y;

	newColor = tex2D(_Backbuffer, float2(pos.x / resolution.x, pos.y / resolution.y));
	//newColor = float4(1.0, 0.0, 0.0, 1.0);

	if (USE_RGB_SHIFT > 0) {
		float r = tex2D(_Backbuffer, float2((pos.x + cos(flow.x)) / resolution.x, (pos.y + sin(flow.y)) / resolution.y)).r;
		float g = tex2D(_Backbuffer, float2(pos.x / resolution.x, pos.y / resolution.y)).g;
		float b = tex2D(_Backbuffer, float2((pos.x - cos(flow.x)) / resolution.x, (pos.y - sin(flow.y)) / resolution.y)).b;

		newColor.rgb = float3(r, g, b);
	}

	if (USE_HUE_SHIFT > 0) {
		newColor.rgb = hueShift(newColor.rgb, length(flow.xy)*shift);
	}

}
else {
	newColor = tex2D(_MainTex, i.uv);
	//newColor = float4(1.0, 1.0, 0.0, 1.0);
}

return newColor;
}
ENDCG

	}
}

Fallback off

}
