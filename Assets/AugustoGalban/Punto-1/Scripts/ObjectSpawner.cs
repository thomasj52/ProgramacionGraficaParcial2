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

    [Header("Variacion")]
    [SerializeField] private float escalaMin = 0.8f;
    [SerializeField] private float escalaMax = 1.4f;
    [SerializeField] private float velocidadRotMin = 10f;
    [SerializeField] private float velocidadRotMax = 90f;

    [Header("UI")]
    [SerializeField] private TextMeshProUGUI textoObjetivo;

    private List<GameObject> _objetosActuales = new List<GameObject>();
    private List<Vector3> _posicionesGrilla = new List<Vector3>();
    private int _indicePosicion = 0;
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

        _prefabObjetivo = prefabsVariados[Random.Range(0, prefabsVariados.Count)];

        GenerarGrilla(); // genera las posiciones antes del for

        bool objetivoCreado = false;

        for (int i = 0; i < cantidadObjetos; i++)
        {
            GameObject prefab;

            if (!objetivoCreado)
            {
                prefab = _prefabObjetivo;
                objetivoCreado = true;
            }
            else
            {
                do
                {
                    prefab = prefabsVariados[Random.Range(0, prefabsVariados.Count)];
                } while (prefab == _prefabObjetivo);
            }

            Vector3 posicion = ObtenerPosicionLibre();

            GameObject obj = Instantiate(prefab, posicion, Random.rotation, transform);

            float escala = Random.Range(escalaMin, escalaMax);
            obj.transform.localScale = Vector3.one * escala;

            ObjetoGirando giro = obj.AddComponent<ObjetoGirando>();
            giro.velocidad = Random.Range(velocidadRotMin, velocidadRotMax);

            _objetosActuales.Add(obj);

            if (prefab == _prefabObjetivo)
            {
                _objetoObjetivo = obj;
                obj.AddComponent<ObjetoObjetivo>();
            }
        }

        ActualizarTexto();
        Debug.Log("Buscar: " + _prefabObjetivo.name);
    }

    private void GenerarGrilla()
    {
        _posicionesGrilla.Clear();

        int cols = Mathf.CeilToInt(Mathf.Sqrt(cantidadObjetos * (areaSpawn.x / areaSpawn.y)));
        int rows = Mathf.CeilToInt((float)cantidadObjetos / cols);

        float stepX = (areaSpawn.x * 2f) / cols;
        float stepY = (areaSpawn.y * 2f) / rows;

        for (int r = 0; r < rows; r++)
        {
            for (int c = 0; c < cols; c++)
            {
                Vector3 pos = transform.position + new Vector3(
                    -areaSpawn.x + stepX * c + stepX * 0.5f + Random.Range(-stepX * 0.3f, stepX * 0.3f),
                    -areaSpawn.y + stepY * r + stepY * 0.5f + Random.Range(-stepY * 0.3f, stepY * 0.3f),
                    Random.Range(-areaSpawn.z, areaSpawn.z)
                );
                _posicionesGrilla.Add(pos);
            }
        }

        // Mezclar para que el objetivo no siempre aparezca en el mismo lugar
        for (int i = _posicionesGrilla.Count - 1; i > 0; i--)
        {
            int j = Random.Range(0, i + 1);
            (_posicionesGrilla[i], _posicionesGrilla[j]) = (_posicionesGrilla[j], _posicionesGrilla[i]);
        }

        _indicePosicion = 0;
    }

    private Vector3 ObtenerPosicionLibre()
    {
        if (_indicePosicion < _posicionesGrilla.Count)
            return _posicionesGrilla[_indicePosicion++];

        // Fallback por si se acabaron las celdas
        return transform.position + new Vector3(
            Random.Range(-areaSpawn.x, areaSpawn.x),
            Random.Range(-areaSpawn.y, areaSpawn.y),
            Random.Range(-areaSpawn.z, areaSpawn.z)
        );
    }

    private void ActualizarTexto()
    {
        if (textoObjetivo != null)
            textoObjetivo.text = "Buscar: " + _prefabObjetivo.name;
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
        Gizmos.color = new Color(0f, 1f, 0f, 0.25f);
        Gizmos.DrawCube(transform.position, areaSpawn * 2f);
        Gizmos.color = Color.green;
        Gizmos.DrawWireCube(transform.position, areaSpawn * 2f);
    }
}