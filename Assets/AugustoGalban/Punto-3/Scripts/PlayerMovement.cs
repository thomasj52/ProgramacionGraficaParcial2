using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class PlayerMovement : MonoBehaviour
{
    [Header("Movimiento")]
    [SerializeField] private float velocidad = 5f;

    private Rigidbody _rb;
    private float _inputH;

    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
        _rb.freezeRotation = true;
    }

    private void Update()
    {
        _inputH = Input.GetAxisRaw("Horizontal"); // A/D o flechas izq/der
    }

    private void FixedUpdate()
    {
        Vector3 movimiento = new Vector3(_inputH, 0f, 0f) * velocidad * Time.fixedDeltaTime;
        _rb.MovePosition(_rb.position + movimiento);
    }
}