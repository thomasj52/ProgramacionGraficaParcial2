using UnityEngine;

// Cámara en primera persona estilo juego (Built-in RP).
// Camina, mira con el mouse, salta y le afecta la gravedad. NO vuela.
// Ponelo en el GameObject de la CÁMARA (la que tiene los post-process).
// Al agregarlo, Unity le suma solo un CharacterController.
//   WASD  -> caminar
//   Mouse -> mirar
//   Space -> saltar
//   Esc   -> liberar el cursor | Click izquierdo -> volver a capturarlo
[RequireComponent(typeof(CharacterController))]
public class FirstPersonController : MonoBehaviour
{
    [Header("Movimiento")]
    public float moveSpeed = 6f;
    public float jumpHeight = 1.5f;
    public float gravity = -20f;

    [Header("Mouse")]
    public float mouseSensitivity = 2f;
    public bool invertY = false;

    private CharacterController controller;
    private float yaw;
    private float pitch;
    private float velocityY;

    private void Start()
    {
        controller = GetComponent<CharacterController>();

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

        if (Cursor.lockState == CursorLockMode.Locked)
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
        // Direcciones horizontales: usamos SOLO el giro (yaw), no la inclinación.
        // Así, aunque mires al piso o al cielo, caminás derecho.
        Vector3 forward = Quaternion.Euler(0f, yaw, 0f) * Vector3.forward;
        Vector3 right = Quaternion.Euler(0f, yaw, 0f) * Vector3.right;

        float x = (Input.GetKey(KeyCode.D) ? 1f : 0f) - (Input.GetKey(KeyCode.A) ? 1f : 0f);
        float z = (Input.GetKey(KeyCode.W) ? 1f : 0f) - (Input.GetKey(KeyCode.S) ? 1f : 0f);
        Vector3 move = (forward * z + right * x).normalized * moveSpeed;

        // Gravedad y salto
        if (controller.isGrounded)
        {
            if (velocityY < 0f) velocityY = -2f; // que quede pegado al piso

            if (Input.GetKeyDown(KeyCode.Space))
                velocityY = Mathf.Sqrt(jumpHeight * -2f * gravity); // fórmula de salto
        }
        else
        {
            velocityY += gravity * Time.deltaTime; // cae
        }

        Vector3 velocity = move + Vector3.up * velocityY;
        controller.Move(velocity * Time.deltaTime);
    }

    private void SetCursor(bool locked)
    {
        Cursor.lockState = locked ? CursorLockMode.Locked : CursorLockMode.None;
        Cursor.visible = !locked;
    }
}