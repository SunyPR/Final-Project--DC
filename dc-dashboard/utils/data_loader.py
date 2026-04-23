import pandas as pd
import numpy as np
from datetime import datetime, timedelta

def get_mock_telemetry():
    # Genera datos simulados para la demo en vivo
    now = datetime.now()
    data = {
        'Timestamp': [now - timedelta(hours=i) for i in range(24)],
        'PUE': np.random.uniform(1.2, 1.8, 24)
    }
    return pd.DataFrame(data)