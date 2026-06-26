using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class WaterWaves : MonoBehaviour
{
    private void OnTriggerEnter2D(Collider2D collision)
    {
        Vector2 hitPoint = collision.transform.position;
        Debug.Log(hitPoint);
    }


}
