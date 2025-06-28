# Progetto Demo LLM

Questo repository fornisce un’infrastruttura completa per eseguire un servizio LLM basato su `llama.cpp` insieme a un'applicazione Spring Boot che ne sfrutta le API.

## Componenti

1. **llm-server**: server Docker basato su [llama.cpp](https://github.com/ggml-org/llama.cpp) che scarica automaticamente un modello GGUF pre-quantizzato e espone un endpoint HTTP per generare completamenti testuali.
2. **spring-llm**: applicazione Spring Boot che espone endpoint REST per inoltrare richieste al server LLM.
3. **docker-compose.yaml**: orchestrazione locale di entrambi i servizi.
4. **k8s-demo-llm.yaml**: manifest Kubernetes per deploy in namespace dedicato.
5. **deploy.sh**: script bash pronto all'uso per il deploy su kubernetes

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
├── deploy.sh
└── .gitignore
```

## Prerequisiti

- Docker & Docker Compose
- Java 21+ e Maven 3.9+
- `kubectl` 
- k3d (o simili, come Minikube/kind/k3s)

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
sh deploy.sh
```

```markdown
**⚠️ AVVISO IMPORTANTE**

Lo script è stato testato solo sull'ambiente Kubernetes **k3d**, ma può essere facilmente adattato a qualsiasi altro Kubernetes locale (es. Minikube).

Nel caso si usi un ambiente Kubernetes diverso da k3d, prima di lanciare lo script, adattare le righe del file (24-26) con i relativi comandi di creazione cluster e import delle immagini docker per l'ambiente Kubernetes locale scelto.

```

Lo script prevede i seguenti passaggi:
1. Build delle immagini docker locali
2. Creazione cluster `demo-llm-cluster` sull'ambiente Kubernetes locale
3. Import delle immagini generate al punto 1 sull'ambiente Kubernetes locale
4. Creazione del namespace k8s `demo-llm`.
5. Applicazione del manifest k8s `k8s-demo-llm.yaml`
6. Port forwarding della porta 80 del cluster sulla porta 8080 locale

- **llm-server** è esposto solo internamente come `ClusterIP` all’indirizzo `llm-server:80`.
- **spring-llm** è esposto esternamente come `LoadBalancer` sulla porta `8080` locale (internamente al cluster sulla porta 80).

## Personalizzazioni

- Modificare l’URL o il percorso del modello nel `Dockerfile` di **llm-server** per usare modelli differenti.
- Regolare le variabili di ambiente e le porte secondo le proprie esigenze.
- Modificare lo script `deploy.sh` a seconda dell'ambiente Kubernetes locale installato