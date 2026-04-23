import plotly.express as px

def create_pue_chart(df):
    fig = px.line(df, x='Timestamp', y='PUE', title='Tendencia de PUE (Últimas 24h)')
    fig.update_layout(template="plotly_dark", font_color="#c9a84c")
    return fig