using UnityEngine;

// Ponelo en el GameObject del PERSONAJE (el que siempre debe verse).
// Cada frame manda a TODOS los shaders dónde está el personaje en pantalla
// y a qué distancia está de la cámara, usando una variable global.
[ExecuteAlways] // tambien funciona en el editor, sin darle Play
public class CharacterOcclusion : MonoBehaviour
{
    [Tooltip("Cámara que renderiza. Si lo dejás vacío usa Camera.main")]
    [SerializeField] private Camera targetCamera;

    [Tooltip("Nombre de la variable global. Debe coincidir EXACTO con la del shader")]
    [SerializeField] private string shaderProperty = "_PlayerViewportPos";

    [Tooltip("Cuánto subir el punto de mira desde los pies. Subilo hasta el pecho/cintura del personaje")]
    [SerializeField] private float heightOffset = 1f;

    private void OnEnable() { UpdatePlayerPosition(); }
    private void LateUpdate() { UpdatePlayerPosition(); }

    private void UpdatePlayerPosition()
    {
        Camera cam = targetCamera != null ? targetCamera : Camera.main;
        if (cam == null) return;

        // Punto al que apunta el agujero: la posición del personaje subida un poco,
        // así apunta al medio del cuerpo en vez de a los pies.
        Vector3 aimPoint = transform.position + Vector3.up * heightOffset;

        // Posición de ese punto en pantalla: x e y van de 0 a 1
        Vector3 viewportPos = cam.WorldToViewportPoint(aimPoint);

        // Distancia real de ese punto a la cámara (en unidades de mundo)
        float distanceToCamera = Vector3.Distance(cam.transform.position, aimPoint);

        // Relación de aspecto (ancho/alto) para que el agujero sea un círculo y no un óvalo
        float aspect = (float)cam.pixelWidth / cam.pixelHeight;

        // Empaquetamos todo en un solo Vector4:
        // x, y = posición en pantalla | z = distancia a la cámara | w = aspect ratio
        Vector4 data = new Vector4(viewportPos.x, viewportPos.y, distanceToCamera, aspect);

        // Lo mandamos a TODOS los shaders de la escena a la vez
        Shader.SetGlobalVector(shaderProperty, data);
    }
}