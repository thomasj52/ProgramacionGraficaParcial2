using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DetectiveMovement : MonoBehaviour
{
    public float speed = 5f;
    public float mouseSensitivity = 2f;

    private Camera playerCamera;
    private float verticalRotation = 0f;

    [SerializeField] private Material material;
    [SerializeField] private GameObject DetectivesPlanes;
    [SerializeField] private Shader readerShader;
    [SerializeField] private Shader normalShader;
    [SerializeField] private Manager manager;
    

    void Start()
    {
        playerCamera = Camera.main;
        Cursor.lockState = CursorLockMode.Locked; // bloquea y oculta el cursor
    }

    void Update()
    {
        // Rotación horizontal del jugador
        float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity;
        transform.Rotate(Vector3.up * mouseX);

        // Rotación vertical de la cámara
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity;
        verticalRotation -= mouseY;
        verticalRotation = Mathf.Clamp(verticalRotation, -80f, 80f);
        playerCamera.transform.localRotation = Quaternion.Euler(verticalRotation, 0f, 0f);

        // Movimiento WASD
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");

        Vector3 move = transform.right * horizontal + transform.forward * vertical;
        transform.Translate(move * speed * Time.deltaTime, Space.World);

        if (Input.GetMouseButtonDown(0))
        {
            DetectivesPlanes.SetActive(false);
            manager.isDetectiveOn = false;
        }
        if (Input.GetMouseButtonDown(1))
        {
            DetectivesPlanes.SetActive(true);
            manager.isDetectiveOn = true;
        }
    }
}
