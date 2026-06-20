using UnityEngine;
using System.Collections.Generic;
using TMPro;

public class ObjectSpawner : MonoBehaviour
{
    [Header("Prefabs variados")]
    [SerializeField] private List<GameObject> prefabsVariados;

    [Header("Cantidad y area")]
    [SerializeField] private int cantidadObjetos = 20;
    [SerializeField] private Vector3 areaSpawn = new Vector3(10f, 5f, 2f);

    [Header("Separacion entre objetos")]
    [SerializeField] private float distanciaMinima = 2.5f;

    [Header("Variacion")]
    [SerializeField] private float escalaMin = 0.8f;
    [SerializeField] private float escalaMax = 1.4f;

    [SerializeField] private float velocidadRotMin = 10f;
    [SerializeField] private float velocidadRotMax = 90f;


    [Header("UI")]
    [SerializeField] private TextMeshProUGUI textoObjetivo;


    private List<GameObject> _objetosActuales = new List<GameObject>();

    private GameObject _objetoObjetivo;
    private GameObject _prefabObjetivo;


    private void Start()
    {
        Popular();
    }


    public void Popular()
    {
        LimpiarObjetos();


        if (prefabsVariados.Count == 0)
        {
            Debug.LogError("No hay prefabs asignados.");
            return;
        }


        // Elegimos qué objeto hay que buscar
        _prefabObjetivo =
            prefabsVariados[Random.Range(0, prefabsVariados.Count)];


        bool objetivoCreado = false;


        for (int i = 0; i < cantidadObjetos; i++)
        {

            GameObject prefab;


            // Creamos una sola instancia del objetivo
            if (!objetivoCreado)
            {
                prefab = _prefabObjetivo;
                objetivoCreado = true;
            }
            else
            {
                do
                {
                    prefab =
                    prefabsVariados[
                    Random.Range(0, prefabsVariados.Count)
                    ];

                } while (prefab == _prefabObjetivo);
            }



            Vector3 posicion = ObtenerPosicionLibre();



            GameObject obj = Instantiate(
                prefab,
                posicion,
                Random.rotation,
                transform
            );



            // Escala random
            float escala =
                Random.Range(escalaMin, escalaMax);

            obj.transform.localScale =
                Vector3.one * escala;



            // Giro
            ObjetoGirando giro =
                obj.AddComponent<ObjetoGirando>();

            giro.velocidad =
                Random.Range(
                    velocidadRotMin,
                    velocidadRotMax
                );



            _objetosActuales.Add(obj);



            // Marcamos el objetivo real
            if (prefab == _prefabObjetivo)
            {
                _objetoObjetivo = obj;

                obj.AddComponent<ObjetoObjetivo>();
            }

        }



        ActualizarTexto();


        Debug.Log(
            "Buscar: " + _prefabObjetivo.name
        );
    }



    private Vector3 ObtenerPosicionLibre()
    {

        int intentos = 100;


        while (intentos > 0)
        {

            intentos--;


            Vector3 posicion =
                transform.position +
                new Vector3(
                    Random.Range(
                        -areaSpawn.x,
                        areaSpawn.x
                    ),

                    Random.Range(
                        -areaSpawn.y,
                        areaSpawn.y
                    ),

                    Random.Range(
                        -areaSpawn.z,
                        areaSpawn.z
                    )
                );



            bool ocupado = false;



            foreach (GameObject obj in _objetosActuales)
            {

                if (obj == null)
                    continue;



                float distancia =
                    Vector3.Distance(
                        posicion,
                        obj.transform.position
                    );



                if (distancia < distanciaMinima)
                {
                    ocupado = true;
                    break;
                }

            }



            if (!ocupado)
                return posicion;

        }



        // Si no encuentra lugar devuelve una posicion random
        return transform.position +
               Random.insideUnitSphere;
    }



    private void ActualizarTexto()
    {

        if (textoObjetivo != null)
        {
            textoObjetivo.text =
                "Buscar: " +
                _prefabObjetivo.name;
        }

    }



    public void LimpiarObjetos()
    {

        foreach (GameObject obj in _objetosActuales)
        {
            if (obj != null)
                Destroy(obj);
        }


        _objetosActuales.Clear();

    }



    private void OnDrawGizmos()
    {

        Gizmos.color =
            new Color(
                0f,
                1f,
                0f,
                0.25f
            );


        Gizmos.DrawCube(
            transform.position,
            areaSpawn * 2f
        );


        Gizmos.color =
            Color.green;


        Gizmos.DrawWireCube(
            transform.position,
            areaSpawn * 2f
        );

    }

}