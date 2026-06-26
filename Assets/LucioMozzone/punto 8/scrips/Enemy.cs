using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    [SerializeField] private GameObject readableObj;
    [SerializeField] private GameObject visibleObj;
    [SerializeField] private Manager manager;
    void Update()
    {
        if (manager.isDetectiveOn)
        {
            readableObj.SetActive(true);
            visibleObj.SetActive(false);
        }
        else
        {
            readableObj.SetActive(false);
            visibleObj.SetActive(true);

        }
    }
}


