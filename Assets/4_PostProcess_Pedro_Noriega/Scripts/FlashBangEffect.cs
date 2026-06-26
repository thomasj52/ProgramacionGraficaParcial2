using UnityEngine;

// Efecto de pantalla completa "flash-bang" para Built-in Render Pipeline.
// Ponelo en el GameObject de la CÁMARA.
// Apretás F -> la pantalla se pone blanca de golpe y se desvanece sola.
[RequireComponent(typeof(Camera))]
public class FlashBangEffect : MonoBehaviour
{
    [Tooltip("Material que usa el shader del flash-bang (lo creás en Amplify)")]
    public Material flashMaterial;

    [Tooltip("Tecla para disparar el destello")]
    public KeyCode triggerKey = KeyCode.F;

    [Tooltip("Cuántos segundos tarda en apagarse el destello")]
    public float fadeDuration = 1.5f;

    private float intensity = 0f;

    private void Update()
    {
        // Al apretar la tecla, el destello salta a su máximo
        if (Input.GetKeyDown(triggerKey))
            intensity = 1f;

        // Y cada frame baja de a poco hasta apagarse
        if (intensity > 0f)
            intensity -= Time.deltaTime / fadeDuration;

        intensity = Mathf.Clamp01(intensity);
    }

    // Unity llama a esto con la imagen ya renderizada (src) antes de mostrarla.
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // Si no hay material asignado, dejamos pasar la imagen sin tocar
        if (flashMaterial == null)
        {
            Graphics.Blit(src, dest);
            return;
        }

        // Le pasamos al shader cuánta intensidad de flash hay ahora mismo
        flashMaterial.SetFloat("_FlashAmount", intensity);

        // Pasamos la imagen por nuestro material y la mostramos
        Graphics.Blit(src, dest, flashMaterial);
    }
}