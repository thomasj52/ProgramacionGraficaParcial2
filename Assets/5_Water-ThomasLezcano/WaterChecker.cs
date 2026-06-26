using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterChecker: MonoBehaviour
{
    [SerializeField] private Material mat; // arrastrá el epicentro en el Inspector

    void Update()
    {
        mat.SetVector("_SplashPos", transform.position);
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag == "Water")
        {

        }
    }
}
