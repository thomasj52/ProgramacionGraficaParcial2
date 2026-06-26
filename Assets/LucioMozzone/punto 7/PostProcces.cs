using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcces : MonoBehaviour
{

    [SerializeField] private Shader shader;
    private Material material;


    private void Awake()
    {
        material = new Material(shader);
    }


    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);


    }
    void Start()
    {
        
    }

    [Header("Límites de movimiento (eje X)")]
    public float limiteIzquierdo = -5f;
    public float limiteDerecho = 5f;

    [Header("Velocidad")]
    public float velocidad = 2f;

    [Header("Objetivo a mirar (pivote)")]
    public Transform objetivo;

    private int direccion = 1;

    void Update()
    {
        transform.Translate(Vector3.right * direccion * velocidad * Time.deltaTime, Space.World);

        if (transform.position.x >= limiteDerecho)
        {
            transform.position = new Vector3(limiteDerecho, transform.position.y, transform.position.z);
            direccion = -1;
        }
        else if (transform.position.x <= limiteIzquierdo)
        {
            transform.position = new Vector3(limiteIzquierdo, transform.position.y, transform.position.z);
            direccion = 1;
        }

        if (objetivo != null)
        {
            transform.LookAt(objetivo);
        }
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Vector3 izq = new Vector3(limiteIzquierdo, transform.position.y, transform.position.z);
        Vector3 der = new Vector3(limiteDerecho, transform.position.y, transform.position.z);
        Gizmos.DrawLine(izq, der);
        Gizmos.DrawWireSphere(izq, 0.3f);
        Gizmos.DrawWireSphere(der, 0.3f);

        if (objetivo != null)
        {
            Gizmos.color = Color.cyan;
            Gizmos.DrawLine(transform.position, objetivo.position);
        }
    }
}
