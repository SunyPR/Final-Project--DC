import streamlit as st

st.header("⚡ Eficiencia Energética (U3)")

st.subheader("Calculadora de PUE (Power Usage Effectiveness)")
it_load = st.number_input("Carga de Equipos IT (kW)", value=100.0)
total_load = st.number_input("Energía Total Instalación (kW)", value=160.0)

if it_load > 0:
    pue = total_load / it_load
    st.metric("PUE Actual", f"{pue:.2f}")
    
    if pue <= 1.5:
        st.success("Eficiencia Excelente (Tier IV Standard)")
    else:
        st.warning("Optimización de enfriamiento requerida")