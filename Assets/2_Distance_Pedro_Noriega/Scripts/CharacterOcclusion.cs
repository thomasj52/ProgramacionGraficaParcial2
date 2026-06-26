using UnityEngine;

// Ponelo en el GameObject del PERSONAJE (el que siempre debe verse).
// Cada frame manda a TODOS los shaders dónde está el personaje en pantalla
// y a qué distancia está de la cámara, usando una variable global.
[ExecuteAlways] // tambien funciona en el editor, sin darle Play
public class CharacterOcclusion : MonoBehaviour
{
    [Tooltip("Cámara")]
    [SerializeField] private Camera targetCamera;

    [Tooltip("Nombre de la variable global")]
    [SerializeField] private string shaderProperty = "_PlayerViewportPos";

    [Tooltip("Cuánto subir el punto de mira desde los pies")]
    [SerializeField] private float heightOffset = 1f;

    private void OnEnable() { UpdatePlayerPosition(); }
    private void LateUpdate() { UpdatePlayerPosition(); }

    private void UpdatePlayerPosition()
    {
        Camera cam = targetCamera != null ? targetCamera : Camera.main;
        if (cam == null) return;

        // punto al que apunta el agujero
        Vector3 aimPoint = transform.position + Vector3.up * heightOffset;

        // posición de ese punto en pantalla
        Vector3 viewportPos = cam.WorldToViewportPoint(aimPoint);

        // distancia real de ese punto a la cámara
        float distanceToCamera = Vector3.Distance(cam.transform.position, aimPoint);

        // relación de aspecto (ancho/alto) 
        float aspect = (float)cam.pixelWidth / cam.pixelHeight;

        // empaqueto todo en un solo Vector4
        Vector4 data = new Vector4(viewportPos.x, viewportPos.y, distanceToCamera, aspect);

        // lo mandamos a TODOS los shaders de la escena 
        Shader.SetGlobalVector(shaderProperty, data);
    }
}