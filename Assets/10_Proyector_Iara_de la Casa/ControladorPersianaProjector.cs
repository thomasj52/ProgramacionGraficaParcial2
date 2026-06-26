using UnityEngine;

[ExecuteInEditMode] // Para que funcione en el editor sin dar Play
public class ControladorPersianaProjector : MonoBehaviour
{
    [Header("Referencias")]
    public Light solDeLaEscena; // Tu Directional Light (El sol)

    [Header("Configuración de Luz")]
    public Color colorMediodia = new Color(1f, 0.95f, 0.8f);
    public Color colorAtardecer = new Color(1f, 0.4f, 0.1f);

    private Projector componenteProyector;
    private Material materialPersiana;

    void OnEnable()
    {
        componenteProyector = GetComponent<Projector>();
        if (componenteProyector != null && componenteProyector.material != null)
        {
            // Creamos una instancia para no romper el archivo original del proyecto
            materialPersiana = componenteProyector.material;
        }
    }

    void Update()
    {
        if (solDeLaEscena == null || componenteProyector == null || materialPersiana == null) return;

        // 1. ROTACIÓN: La caja del proyector imita la dirección de los rayos del sol
        transform.rotation = solDeLaEscena.transform.rotation;

        // 2. ALTURA DEL SOL: Calculamos si es de día o de noche (Y de forward va de 0 a -1)
        float alturaSol = solDeLaEscena.transform.forward.y;

        if (alturaSol < 0) // Fase Diurna (El sol está arriba)
        {
            float factorDia = Mathf.Abs(alturaSol); // 1 = Mediodía, 0 = Atardecer

            // 3. PASAMOS INTENSIDAD AL SHADER DE AMPLIFY
            materialPersiana.SetFloat("_SolIntensidad", factorDia * 2.5f);

            // 4. PASAMOS EL COLOR INTERPOLADO AL SHADER DE AMPLIFY
            Color colorActual = Color.Lerp(colorAtardecer, colorMediodia, factorDia);
            materialPersiana.SetColor("_SolColor", colorActual);
        }
        else // Fase Nocturna (Se ocultó el sol)
        {
            // Apagado total del proyector
            materialPersiana.SetFloat("_SolIntensidad", 0f);
        }
    }
}