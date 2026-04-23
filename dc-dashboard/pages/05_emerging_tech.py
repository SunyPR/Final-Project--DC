import streamlit as st

st.header("🚀 Tecnologías Emergentes (U4)")

st.subheader("Radar de Adopción 2024-2030")
tech_data = {
    "Liquid Cooling": "Adopción Temprana (IA Clusters)",
    "Edge Data Centers": "Crecimiento Acelerado",
    "Generadores de Hidrógeno": "Etapa de Pilotaje",
    "Quantum Ready Racks": "Investigación"
}

for tech, stage in tech_data.items():
    with st.expander(f"Ver detalles de: {tech}"):
        st.write(f"Estado actual: **{stage}**")
        st.write("Impacto: Alta eficiencia operativa y reducción de huella de carbono.")