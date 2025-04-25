from flask import Flask, render_template
import psycopg2

app = Flask(__name__)

def get_filtered_data():
    conn = psycopg2.connect(
        host="localhost",  
        database="flinkdb",
        user="flinkuser",
        password="flinkpassword"
    )
    cur = conn.cursor()
    cur.execute("""
        SELECT sensor_id, temperature, ts
        FROM postgres_temperature_data_filtered
        ORDER BY ts DESC
        LIMIT 100
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows

@app.route("/")
def table_view():
    data = get_filtered_data()
    return render_template("table.html", data=data)

if __name__ == "__main__":
    app.run(debug=True)