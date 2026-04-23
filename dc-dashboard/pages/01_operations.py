import streamlit as st
import pandas as pd
import numpy as np

st.header("🌐 Gestión de Operaciones (U3)")

col1, col2, col3 = st.columns(3)
col1.metric("Uptime Global", "99.998%", "0.001%")
col2.metric("Incidentes Activos", "2", "-1")
col3.metric("Tickets Cerrados (24h)", "14", "4")

st.subheader("Log de Incidentes Recientes")
df_incidents = pd.DataFrame({
    'ID': ['INC-001', 'INC-002', 'INC-003'],
    'Severidad': ['Alta', 'Media', 'Baja'],
    'Descripción': ['Falla en UPS Rack 4', 'Cambio de Disco SAN', 'Mantenimiento Preventivo HVAC'],
    'Estado': ['En Progreso', 'Resuelto', 'Programado']
})
st.table(df_incidents)