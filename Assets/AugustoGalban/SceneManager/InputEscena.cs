using UnityEngine;

public class InputEscena : MonoBehaviour
{
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return) || Input.GetKeyDown(KeyCode.KeypadEnter))
        {
            SceneController.Instance.SiguienteEscena();
        }
    }
}