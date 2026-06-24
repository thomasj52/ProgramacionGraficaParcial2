using UnityEngine;

// Cámara libre para volar por la escena y ver el shader desde todos los ángulos.
// Ponela en el GameObject de la CÁMARA.
//   WASD  -> adelante / izquierda / atrás / derecha
//   Space -> subir
//   Shift -> bajar
//   Mouse -> mirar alrededor
//   Ctrl  -> moverse más rápido (opcional)
//   Esc   -> liberar el cursor | Click izquierdo -> volver a capturarlo
public class FreeFlyCamera : MonoBehaviour
{
    [Header("Movimiento")]
    public float moveSpeed = 8f;
    public float sprintMultiplier = 3f;

    [Header("Mouse")]
    public float mouseSensitivity = 2f;
    public bool invertY = false;

    private float yaw;
    private float pitch;

    private void Start()
    {
        // Tomamos la rotación inicial para no pegar un salto al empezar
        Vector3 e = transform.eulerAngles;
        yaw = e.y;
        pitch = e.x;
        SetCursor(true);
    }

    private void Update()
    {
        // Liberar / capturar el cursor
        if (Input.GetKeyDown(KeyCode.Escape)) SetCursor(false);
        if (Input.GetMouseButtonDown(0) && Cursor.lockState != CursorLockMode.Locked) SetCursor(true);

        // Solo movemos la cámara mientras el cursor está capturado
        if (Cursor.lockState != CursorLockMode.Locked) return;

        Look();
        Move();
    }

    private void Look()
    {
        float mx = Input.GetAxis("Mouse X") * mouseSensitivity;
        float my = Input.GetAxis("Mouse Y") * mouseSensitivity;

        yaw += mx;
        pitch += invertY ? my : -my;
        pitch = Mathf.Clamp(pitch, -89f, 89f); // que no se dé vuelta de cabeza

        transform.rotation = Quaternion.Euler(pitch, yaw, 0f);
    }

    private void Move()
    {
        float speed = moveSpeed;
        if (Input.GetKey(KeyCode.LeftControl) || Input.GetKey(KeyCode.RightControl))
            speed *= sprintMultiplier;

        Vector3 dir = Vector3.zero;
        if (Input.GetKey(KeyCode.W)) dir += transform.forward;
        if (Input.GetKey(KeyCode.S)) dir -= transform.forward;
        if (Input.GetKey(KeyCode.D)) dir += transform.right;
        if (Input.GetKey(KeyCode.A)) dir -= transform.right;
        if (Input.GetKey(KeyCode.Space)) dir += Vector3.up;       // subir
        if (Input.GetKey(KeyCode.LeftShift)) dir -= Vector3.up;   // bajar

        transform.position += dir.normalized * speed * Time.deltaTime;
    }

    private void SetCursor(bool locked)
    {
        Cursor.lockState = locked ? CursorLockMode.Locked : CursorLockMode.None;
        Cursor.visible = !locked;
    }
}