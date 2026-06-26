using UnityEngine;

public class SunController : MonoBehaviour
{
    [Header("Velocidad")]
    public float daySpeed = 10f; // cuanto más alto, más rápido pasa el día

    [Header("Colores según hora")]
    public Color dawnColor = new Color(1f, 0.4f, 0.1f);      // amanecer - naranja
    public Color noonColor = new Color(1f, 0.95f, 0.7f);     // mediodía - blanco cálido
    public Color duskColor = new Color(1f, 0.3f, 0.05f);     // atardecer - rojo
    public Color nightColor = new Color(0.05f, 0.05f, 0.2f); // noche - azul oscuro

    private Material projectorMaterial;
    private float timeOfDay = 0f; // 0 a 1 representa un día completo

    void Start()
    {
        // Agarra el material del Projector automáticamente
        Projector proj = GetComponent<Projector>();
        if (proj != null)
            projectorMaterial = proj.material;
    }

    void Update()
    {
        timeOfDay += Time.deltaTime * daySpeed / 100f;
        if (timeOfDay > 1f) timeOfDay = 0f;

        // Solo cambia el color, no mueve nada
        Color currentColor = GetSunColor();
        if (projectorMaterial != null)
            projectorMaterial.SetColor("_LightColor", currentColor);
    }

    Color GetSunColor()
    {
        // 0.0 - 0.25 → amanecer
        // 0.25 - 0.5 → mediodía
        // 0.5 - 0.75 → atardecer
        // 0.75 - 1.0 → noche

        if (timeOfDay < 0.25f)
            return Color.Lerp(nightColor, dawnColor, timeOfDay / 0.25f);
        else if (timeOfDay < 0.5f)
            return Color.Lerp(dawnColor, noonColor, (timeOfDay - 0.25f) / 0.25f);
        else if (timeOfDay < 0.75f)
            return Color.Lerp(noonColor, duskColor, (timeOfDay - 0.5f) / 0.25f);
        else
            return Color.Lerp(duskColor, nightColor, (timeOfDay - 0.75f) / 0.25f);
    }
}