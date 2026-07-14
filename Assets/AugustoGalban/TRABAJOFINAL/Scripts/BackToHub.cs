using UnityEngine;
using UnityEngine.SceneManagement;

public class BackToHub : MonoBehaviour
{
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            SceneManager.LoadScene("HUB_Portales");
        }
    }
}