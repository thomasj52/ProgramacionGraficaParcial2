using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMove : MonoBehaviour
{
   
    [SerializeField] private float speed;
    [SerializeField] private Material mat;

    [SerializeField] private Texture textureLights;
    [SerializeField] private Texture textureRays;
    [SerializeField] private Texture textureThermal;

    void Update()
    {
        // Movimiento hacia arriba
        if (Input.GetKey(KeyCode.W))
        {
            transform.position += Vector3.up * speed * Time.deltaTime;
        }

        // Movimiento hacia abajo
        if (Input.GetKey(KeyCode.S))
        {
            transform.position += Vector3.down * speed * Time.deltaTime;
        }

        if (Input.GetKey(KeyCode.U))
        {
            mat.SetTexture("_ProjectorTexture", textureLights);
        }

        if (Input.GetKey(KeyCode.I))
        {
            mat.SetTexture("_ProjectorTexture", textureThermal);
        }

        if (Input.GetKey(KeyCode.O))
        {
            mat.SetTexture("_ProjectorTexture", textureRays);
        }
    }
}
