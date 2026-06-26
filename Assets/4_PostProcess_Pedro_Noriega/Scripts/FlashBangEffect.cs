using UnityEngine;


[RequireComponent(typeof(Camera))]
public class FlashBangEffect : MonoBehaviour
{
    [Tooltip("Material que usa el shader del flashbang")]
    public Material flashMaterial;

    [Tooltip("Tecla para dispararlo")]
    public KeyCode triggerKey = KeyCode.F;

    [Tooltip("Cuantos segundos tarda en apagarse")]
    public float fadeDuration = 1.5f;

    private float intensity = 0f;

    private void Update()
    {
        // al apretar la tecla salta a su máximo
        if (Input.GetKeyDown(triggerKey))
            intensity = 1f;

        // y cada frame baja de a poco hasta apagarse
        if (intensity > 0f)
            intensity -= Time.deltaTime / fadeDuration;

        intensity = Mathf.Clamp01(intensity);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // si no hay material asignado, dejo pasar la imagen sin tocar
        if (flashMaterial == null)
        {
            Graphics.Blit(src, dest);
            return;
        }

        // le paso al shader cuanta intensidad de flash hay ahora mismo
        flashMaterial.SetFloat("_FlashAmount", intensity);

        // pasamos la imagen por nuestro material y la mostramos
        Graphics.Blit(src, dest, flashMaterial);
    }
}