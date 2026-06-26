using UnityEngine;

public class PantallaFin : MonoBehaviour
{
    public void OnExitClick()
    {
        SceneController.Instance.IrAMenu();
    }
}