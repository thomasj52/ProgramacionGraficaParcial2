using UnityEngine;

// Efecto de pantalla completa "cámara en mano / handycam" para Built-in Render Pipeline.
// Ponelo en el GameObject de la CÁMARA.
// Apretás la tecla (por defecto C) -> entra/sale del modo filmadora, con una transición suave.
[RequireComponent(typeof(Camera))]
public class HandycamEffect : MonoBehaviour
{
    [Tooltip("material que usa el shader de la camara en mano")]
    public Material effectMaterial;

    [Tooltip("tecla para encender/apagar el modo cámara")]
    public KeyCode toggleKey = KeyCode.C;

    [Tooltip("qué tan rapido entra/sale del efecto")]
    public float transitionSpeed = 6f;

    private bool isOn = false;
    private float amount = 0f; // 0 = apagado, 1 = prendido

    private void Update()
    {
        // la tecla alterna entre prendido y apagado
        if (Input.GetKeyDown(toggleKey))
            isOn = !isOn;

        // movemos "amount" suavemente hacia el objetivo (1 o 0)
        float target = isOn ? 1f : 0f;
        amount = Mathf.MoveTowards(amount, target, transitionSpeed * Time.deltaTime);
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (effectMaterial == null)
        {
            Graphics.Blit(src, dest);
            return;
        }

        // le pasamos al shader si la cámara está encendida (0..1)
        effectMaterial.SetFloat("_CameraOn", amount);
        Graphics.Blit(src, dest, effectMaterial);
    }
}