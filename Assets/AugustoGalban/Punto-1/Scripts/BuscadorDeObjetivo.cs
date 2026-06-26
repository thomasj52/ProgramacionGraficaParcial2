using UnityEngine;
using System.Collections;

public class BuscadorDeObjetivo : MonoBehaviour
{
    [SerializeField] private Camera camara;
    [SerializeField] private ObjectSpawner spawner;
    [SerializeField] private float distanciaMaxima = 50f;

    [Header("Captura")]
    [SerializeField] private Camera camaraCaptura;
    [SerializeField] private Camera camaraJugador;

    [Header("Zoom")]
    [SerializeField] private float fovNormal = 60f;       
    [SerializeField] private float fovZoom = 20f;         
    [SerializeField] private float velocidadZoom = 8f;  

    [SerializeField] private float esperaAntesDeFoto = 0.8f;   
    [SerializeField] private float esperaEnZoom = 1f;

    [Header("UI")]
    [SerializeField] private GameObject panelFoto;

    private void Awake()
    {
        if (camara == null)
            camara = Camera.main;

    }

    private void Start()
    {
        AudioListener listener = camaraCaptura.GetComponent<AudioListener>();
        if (listener != null)
            Destroy(listener);
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = camara.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(ray, out RaycastHit hit, distanciaMaxima))
            {
                ObjetoObjetivo objetivo = hit.collider.GetComponentInParent<ObjetoObjetivo>();

                if (objetivo != null)
                {
                    Debug.Log("¡Objetivo encontrado!");
                    StopAllCoroutines();
                    StartCoroutine(ZoomYCaptura(objetivo.transform));
                }
            }
        }
    }

    private IEnumerator ZoomYCaptura(Transform objetivoTransform)
    {
        Quaternion rotacionOriginal = camaraJugador.transform.rotation;
        float fovOriginal = camaraJugador.fieldOfView;

        Vector3 direccion = objetivoTransform.position - camaraJugador.transform.position;
        Quaternion rotacionObjetivo = Quaternion.LookRotation(direccion);

        float t = 0f;

        while (t < 1f)
        {
            t += Time.deltaTime * velocidadZoom;
            camaraJugador.fieldOfView = Mathf.Lerp(fovNormal, fovZoom, t);
            camaraJugador.transform.rotation = Quaternion.Slerp(rotacionOriginal, rotacionObjetivo, t);
            yield return null;
        }

        camaraJugador.fieldOfView = fovZoom;
        camaraJugador.transform.rotation = rotacionObjetivo;

        yield return new WaitForSeconds(esperaAntesDeFoto); 

        CapturarFoto();

        yield return new WaitForSeconds(esperaEnZoom);

        t = 0f;
        Quaternion rotacionConZoom = camaraJugador.transform.rotation;
        while (t < 1f)
        {
            t += Time.deltaTime * velocidadZoom * 0.5f;
            camaraJugador.fieldOfView = Mathf.Lerp(fovZoom, fovNormal, t);
            camaraJugador.transform.rotation = Quaternion.Slerp(rotacionConZoom, rotacionOriginal, t);
            yield return null;
        }

        camaraJugador.fieldOfView = fovNormal;
        camaraJugador.transform.rotation = rotacionOriginal;

        spawner.Popular();
    }

    private void CapturarFoto()
    {
        camaraCaptura.transform.position = camaraJugador.transform.position;
        camaraCaptura.transform.rotation = camaraJugador.transform.rotation;
        camaraCaptura.fieldOfView = camaraJugador.fieldOfView;
        camaraCaptura.clearFlags = camaraJugador.clearFlags;
        camaraCaptura.backgroundColor = camaraJugador.backgroundColor;

        camaraCaptura.Render();

        StartCoroutine(MostrarFotoTemporalmente());
    }

    private IEnumerator MostrarFotoTemporalmente()
    {
        panelFoto.SetActive(true);
        yield return new WaitForSeconds(2f);
        panelFoto.SetActive(false);
    }
}