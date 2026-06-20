using UnityEngine;

public class ObjetoGirando : MonoBehaviour
{
    public float velocidad = 30f;
    private Vector3 _ejeRotacion;

    private void Awake()
    {
        _ejeRotacion = Random.onUnitSphere;
    }

    private void Update()
    {
        transform.Rotate(_ejeRotacion, velocidad * Time.deltaTime, Space.World);
    }
}