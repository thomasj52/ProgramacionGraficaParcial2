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

    [Header("UI")]
    [SerializeField] private GameObject panelFoto;

    private void Awake()
    {
        if (camara == null)
            camara = Camera.main;
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray =
                camara.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(
                    ray,
                    out RaycastHit hit,
                    distanciaMaxima))
            {
                ObjetoObjetivo objetivo =
                    hit.collider.GetComponent<ObjetoObjetivo>();

                if (objetivo != null)
                {
                    Debug.Log("¡Objetivo encontrado!");

                    EncontroObjetivo();
                }
            }
        }
    }

    private void EncontroObjetivo()
    {
        CapturarFoto();

        Debug.Log("Nueva ronda");

        spawner.Popular();
    }

    private void CapturarFoto()
    {
        camaraCaptura.transform.position =
            camaraJugador.transform.position;

        camaraCaptura.transform.rotation =
            camaraJugador.transform.rotation;

        camaraCaptura.gameObject.SetActive(true);

        camaraCaptura.Render();

        camaraCaptura.gameObject.SetActive(false);

        StopAllCoroutines();

        StartCoroutine(MostrarFotoTemporalmente());
    }

    private IEnumerator MostrarFotoTemporalmente()
    {
        panelFoto.SetActive(true);

        yield return new WaitForSeconds(2f);

        panelFoto.SetActive(false);
    }
}