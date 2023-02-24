using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NightVisionEffect : MonoBehaviour

{
    public Shader currentShader;
    public float contrast = 2;
    public float brightness = 1f;
    public Color nightVisionCollor = Color.white;
    public Texture2D vignetteTexture;
    public Texture2D scanlineTexture;
    public float scanlineAmount = 4f;
    public Texture2D noiseTexture;
    public float noiseXSpeed;


    private Material currentMaterial;

    Material material
    {
        get {
            if (currentMaterial == null) {
                currentMaterial = new Material(currentShader);
                currentMatiral.hideFlags = HideFlags.HideAndDontSave;
            }

            return currentMaterial;
        }
    }
    // Start is called before the first frame update
    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!currentShader && !currentShader.isSupported)
        {
            enabled = false;
        }
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (currentShader != null)
        {
            material.SetFloat("_Contrast", contrast);
            if (vignetteTexture) {
                material.SetTexture("_Vignette", vignetteTexture);
            }

            if (scanlineTexture) {
                material.SetTexture("_ScanlineTex", scanlineTexture);
                material.SetFloat("_ScanlineAmount", scanlineAmount);
            }

            if (noiseTexture) {
                material.setTexture("_NoiseTex", noiseTexture);

                material.SetFloat("_NoiseXSpeed", noiseXSpeed);
                material.SetFloat("_NoiseYSpeed", noiseYSpeed);
            }

            Graphics.Blit(sourceTexture, destTexture, currentMaterial);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    // Update is called once per frame
    void Update()
    {
        contrast = Mathf.Clamp(contrast, 0f,4f);
        brightness = Mathf.Clamp(brightness, 0f, 2f);
        ramdomValue = Random.Range(-1f, 1f);
        distortion = Mathf.Clamp(distortion, -1f, 1f);
        scale = Mathf.Clamp(scale, 0f, 3f);
    }

    void OnDisabled()
    {
        if (currentMaterial)
        {
            DestroyInmediate(currentMaterial);
        }
    }
}
