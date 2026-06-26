using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneController : MonoBehaviour
{
    public static SceneController Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
        DontDestroyOnLoad(gameObject);
    }

    public void SiguienteEscena()
    {
        int actual = SceneManager.GetActiveScene().buildIndex;
        int total = SceneManager.sceneCountInBuildSettings;

        if (actual >= total - 2) 
        {
            SceneManager.LoadScene("Fin");
        }
        else
        {
            SceneManager.LoadScene(actual + 1);
        }
    }

    public void IrAMenu()
    {
        SceneManager.LoadScene("MenuPrincipal");
    }

    public void Salir()
    {
        Application.Quit();
        Debug.Log("Salir"); 
    }
}