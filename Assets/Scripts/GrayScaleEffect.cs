using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GrayScaleEffect : MonoBehaviour

{
    public Shader currentShader;
    public float grayScaleAmount;
    public Material currentMaterial;
    // Start is called before the first frame update
    void Start()
    {
        if (!SystemInfo.supportsImageEffects) {
            enabled = false;
            return;
        }

        if (!currentShader && !currentShader.isSupported) {
            enabled = false;
        }
    }

    // Update is called once per frame
    void Update()
    {
        grayScaleAmount = Mathf.Clamp(grayScaleAmount, 0.0f, 1.0f);
    }

    Material material
    {

        get {
            if (currentMaterial == null) {
                currentMaterial = new Material(currentShader);
                currentMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return currentMaterial;
        }
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) {
        if (currentShader != null)
        {
            material.SetFloat("_LuminosityAmount", grayScaleAmount);
            Graphics.Blit(sourceTexture, destTexture, currentMaterial);
        }
        else {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    void OnDisabled() {
        if (currentMaterial) {
            DestroyInmediate(currentMaterial);
        }
    }
}
