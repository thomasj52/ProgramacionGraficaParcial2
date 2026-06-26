using UnityEngine;

public class MenuPrincipal : MonoBehaviour
{
    public void OnPlayClick()
    {
        SceneController.Instance.SiguienteEscena();
    }

    public void OnExitClick()
    {
        SceneController.Instance.Salir();
    }
}