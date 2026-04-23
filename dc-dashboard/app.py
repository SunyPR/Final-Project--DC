import streamlit as st

st.set_page_config(page_title="DC-Ops Dashboard | Suny Ramirez", layout="wide")

# Estilo personalizado para evitar el tema por defecto
st.markdown("""
    <style>
    .main { background-color: #0e1117; color: #f5f5f0; }
    h1 { color: #c9a84c; }
    </style>
    """, unsafe_allow_html=True)

st.title("🖥️ DC-Ops Central Command")
st.sidebar.title("Navigation")
st.sidebar.info("Select a module to monitor Data Center operations.")

st.write("### Project by: Suny Ricarte Ramirez Perez")
st.write("Exploring the intersection of Data Engineering and DC Administration.")