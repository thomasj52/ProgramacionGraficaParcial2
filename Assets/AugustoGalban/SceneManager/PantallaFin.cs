using UnityEngine;

public class PantallaFin : MonoBehaviour
{
    private void Start()
    {
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }

    public void OnExitClick()
    {
        SceneController.Instance.IrAMenu();
    }
}