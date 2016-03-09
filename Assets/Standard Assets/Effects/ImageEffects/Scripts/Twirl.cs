using System;
using UnityEngine;

namespace UnityStandardAssets.ImageEffects
{
    [ExecuteInEditMode]
    [AddComponentMenu("Image Effects/Displacement/Twirl")]
    public class Twirl : ImageEffectBase
    {
        public Vector2 radius = new Vector2(0.3F,0.3F);
        [Range(0.0f,360.0f)]
        public float angle = 50;
        public Vector2 center = new Vector2 (0.5F, 0.5F);
        private int USE_RGB_SHIFT = 1;


        // Called by camera to apply image effect
        void OnRenderImage (RenderTexture source, RenderTexture destination)
        {
            material.SetVector("leftStick", new Vector2(Input.GetAxis("LeftStickX"), Input.GetAxis("LeftStickY")));
            Debug.Log(1 - Math.Abs(Input.GetAxis("LeftStickY")));
            material.SetVector("rightStick", new Vector2(Input.GetAxis("RightStickX"), Input.GetAxis("RightStickY")));
            material.SetVector("resolution", new Vector2(source.width, source.height));
            Graphics.Blit(source, destination, material);
            material.SetTexture("_Backbuffer", destination);
            //ImageEffects.RenderDistortion (material, source, destination, angle, center, radius);
        }
    }
}
