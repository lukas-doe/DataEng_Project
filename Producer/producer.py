from kafka import KafkaProducer
import json, time, random
from datetime import datetime

producer = KafkaProducer(
    bootstrap_servers='kafka:29092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

while True:
    msg = {
        'timestamp_str': datetime.now().isoformat(),
        'sensor_id': random.randint(1, 10),
        'temperature': round(random.uniform(20, 35), 2)
    }
    producer.send('temperature-data', msg)
    print(f"Sent: {msg}")
    time.sleep(2)