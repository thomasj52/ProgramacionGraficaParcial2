using UnityEngine;

// Aplica un material de post-proceso sobre la imagen final (Built-in Render Pipeline).
// Ponelo en el GameObject de la CÁMARA y arrastrale el material del efecto.
// Sirve para cualquier efecto que se controle con valores del material
// (como el "borracho", que se gradúa con su slider en el inspector).
[RequireComponent(typeof(Camera))]
public class PostProcessEffect : MonoBehaviour
{
    [Tooltip("material que usa el shader del efecto")]
    public Material effectMaterial;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // si no hay material, dejamos pasar la imagen sin tocar
        if (effectMaterial == null)
        {
            Graphics.Blit(src, dest);
            return;
        }

        // pasamos la imagen por el material y la mostramos
        Graphics.Blit(src, dest, effectMaterial);
    }
}