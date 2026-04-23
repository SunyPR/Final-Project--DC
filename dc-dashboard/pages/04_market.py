import streamlit as st
import pandas as pd
import plotly.express as px

st.header("📊 Inteligencia de Mercado - México (U4)")

# Datos basados en tendencias reales
data = {
    'Región': ['Querétaro', 'CDMX', 'Monterrey', 'Estado de México'],
    'Capacidad (MW)': [150, 80, 45, 60],
    'Lat': [20.5881, 19.4326, 25.6866, 19.3553],
    'Lon': [-100.3899, -99.1332, -100.3161, -99.6532]
}
df = pd.DataFrame(data)

# Extra Feature 1: Mapa Interactivo
st.subheader("Mapa de Distribución de Capacidad")
fig_map = px.scatter_mapbox(
    df, lat="Lat", lon="Lon", size="Capacidad (MW)", 
    color="Capacidad (MW)", hover_name="Región", 
    color_continuous_scale=["#4a1a6e", "#c9a84c"], 
    size_max=30, zoom=4.5, mapbox_style="carto-darkmatter"
)
st.plotly_chart(fig_map, use_container_width=True)

# Gráfico de Barras
st.subheader("Capacidad por Región (MW)")
fig_bar = px.bar(
    df, x='Región', y='Capacidad (MW)', 
    color_discrete_sequence=['#c9a84c']
)
fig_bar.update_layout(plot_bgcolor="rgba(0,0,0,0)", paper_bgcolor="rgba(0,0,0,0)")
st.plotly_chart(fig_bar, use_container_width=True)

# Extra Feature 2: Exportación de Datos
st.download_button(
    label="📥 Exportar Datos de Mercado (CSV)",
    data=df.to_csv(index=False).encode('utf-8'),
    file_name='mercado_dc_mexico.csv',
    mime='text/csv',
)

st.info("Fuente: Basado en reportes de Statista y CBRE México 2024-2026.")