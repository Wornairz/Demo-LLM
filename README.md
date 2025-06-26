# Progetto Demo LLM

Questo repository fornisce un’infrastruttura completa per eseguire un servizio LLM basato su `llama.cpp` insieme a un'applicazione Spring Boot che ne sfrutta le API.

## Componenti

1. **llm-server**: server Docker basato su `llama.cpp` che scarica automaticamente un modello GGUF pre-quantizzato e espone un endpoint HTTP per generare completamenti testuali.
2. **spring-llm**: applicazione Spring Boot che espone endpoint REST (`GET` e `POST`) per inoltrare richieste al server LLM.
3. **docker-compose.yaml**: orchestrazione locale di entrambi i servizi.
4. **k8s-demo-llm.yaml**: manifest Kubernetes per deploy in namespace dedicato.
5. **.gitignore**: file di esclusioni comuni.

## Struttura del repository

```text
├── llm-server/
│   ├── Dockerfile
│   └── README.md      # Documentazione specifica per il server LLM
├── llm-spring/
│   ├── Dockerfile
│   └── README.md      # Documentazione specifica per l'app Spring Boot
├── docker-compose.yaml
├── k8s-demo-llm.yaml
└── .gitignore
```

## Prerequisiti

- Docker & Docker Compose
- Java 21+ e Maven 3.9+
- `kubectl`

## Build e run manuale dei singoli container

### LLM server
```bash
cd llm-server
docker build -t demo-llm-server .
docker run --rm -p 9090:8080 demo-llm-server
```

### Spring LLM
```bash
cd spring-llm
docker build -t demo-spring-llm .
docker run --rm -p 8080:8080 \
  -e LLM_API_BASE_URL=http://llama-server:8080 demo-spring-llm
```

## Esecuzione locale con Docker Compose

Dalla radice del repository:

```bash
docker-compose up --build
```

- **llm-server** sarà disponibile su `http://localhost:9090/`
- **spring-llm** sarà disponibile su `http://localhost:8080/`

## Deploy Kubernetes

Per distribuire entrambi i servizi in un cluster Kubernetes, eseguire, dalla radice del repository:

```bash
kubectl apply -f k8s-demo-llm.yaml
```

- Verrà creato il namespace `demo-llm`.
- **llm-server** è esposto solo internamente come `ClusterIP` all’indirizzo `llm-server:80`.
- **spring-llm** è esposto esternamente come `NodePort` sulla porta `30080` del nodo (internamente target 8080).

## Personalizzazioni

- Modificare l’URL o il percorso del modello nel `Dockerfile` di **llm-server** per usare modelli differenti.
- Regolare le variabili di ambiente e le porte secondo le proprie esigenze.