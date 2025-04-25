# Real-time Streaming Backend mit Apache Flink, Kafka & PostgreSQL

Dieses Projekt entstand im Rahmen des Moduls **Data Engineering (DLMDWWDE02)** an der IU und zeigt eine vollständige Echtzeit-Streaming-Architektur auf Basis von Apache Flink, Kafka, PostgreSQL und Python.

## Zielsetzung

Ziel des Projekts ist es, ein skalierbares Backend für eine datenintensive Applikation aufzubauen, das Sensordaten in Echtzeit verarbeitet, filtert und in eine relationale Datenbank schreibt.

---

## Systemarchitektur

Die Anwendung besteht aus folgenden Services:

- **Producer (Python)**: Generiert simulierte Sensordaten und sendet sie an Kafka.
- **Kafka (Confluent Platform)**: Message Broker für die Echtzeit-Datenverteilung.
- **Apache Flink (SQL)**: Echtzeit-Streamverarbeitung und Filterung der Daten.
- **PostgreSQL**: Persistenzschicht für gefilterte Sensordaten.
- **Flask Dashboard (optional)**: Visualisiert Temperaturen > 30 °C in einem Webinterface.

---

## Komponenten

| Service            | Aufgabe                            |
|--------------------|-------------------------------------|
| `producer.py`      | Simuliert Temperaturdaten           |
| `flink-job`        | Flink SQL Setup + Kafka/JDBC JARs   |
| `job.sql`          | Daraus werden Source/Sink-Tabellen + Filter-Logik erstellt|
| `postgres-init`    | Initialisiert PostgreSQL-Tabelle    |
| `docker-compose`   | Orchestriert das gesamte Setup      |

---

## Setup

### 🔧 Voraussetzungen

- Docker + Docker Compose
- (Optional) Python & Flask für lokale Dashboard-Nutzung

### Start

```bash
docker compose up --build
```

**Hinweis**: Der Flink SQL-Job (`INSERT INTO ...`) muss derzeit **manuell** im SQL-Client ausgeführt werden. Siehe unten.

---

## Hintergrund zur manuellen Ausführung

**Warum wird der INSERT nicht automatisch ausgeführt?**

Aufgrund des Timings zwischen dem Flink-SQL-Client und der Verfügbarkeit des PostgreSQL-Containers ließ sich das `INSERT INTO`-Statement im automatisierten Docker-Setup nicht zuverlässig ausführen.

**Workaround**: Der SQL-Job wird manuell über den Flink SQL-Client gestartet.  
Alle anderen Komponenten (Kafka, Producer, PostgreSQL, Flink) laufen automatisch im Compose-Setup.

---

## Nachdem Docker Compose gestartet wurde, muss Flink Job wie folgt im Terminal gestartet werden:

### 1. SQL-Client manuell öffnen, Flink Jobmanager Container ID kann über Befehl "docker ps" im Terminal ermittelt werden:

```bash
docker exec -it <flink-jobmanager-container-id> /bin/bash
sql-client.sh --embedded
```

### 2. Statements aus `job.sql` manuell eingeben, darauf achten dass immer nur ein Statement und danach das jeweils nächste geschrieben wird:

```sql
-- Tabellen & Inserts siehe: flink-job/job.sql
```

---

## Visualisierung

Starte das Flask-Dashboard lokal:

```bash
cd dashboard
pip install -r requirements.txt
python app.py
```

➡️ Öffne `http://localhost:5000`  
Das Dashboard zeigt alle Temperaturen über 30 °C an.

---

## Verzeichnisstruktur

```
.
├── producer/                 # Python-Kafka Producer
├── flink-job/               # Flink-SQL + JARs
│   ├── job.sql
│   └── lib/
├── postgres-init/           # SQL Init-Skript für PostgreSQL
├── dashboard/               # Flask-Webapp (optional)
├── docker-compose.yml
```

---

## Lizenz

Dieses Projekt wurde im Rahmen des IU-Moduls *Data Engineering* entwickelt und dient ausschließlich Bildungszwecken.

---

## Autor

**Lukas Döbbelin**  
Studium Wirtschaftsingenieurwesen (M.Eng.), Schwerpunktmodule: AI & Data Engineering