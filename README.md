# Progetto Demo LLM

Questo repository fornisce un’infrastruttura completa per eseguire su un cluster Kubernetes un servizio LLM basato su `llama.cpp` insieme ad un'applicazione Spring Boot che ne sfrutta le API.

## Componenti

1. **llm-server**: server Docker basato su [llama.cpp](https://github.com/ggml-org/llama.cpp) che scarica automaticamente un modello GGUF pre-quantizzato ed espone un endpoint HTTP per generare completamenti testuali.
2. **spring-llm**: applicazione Spring Boot che espone endpoint REST per inoltrare richieste al server LLM.
3. **docker-compose.yaml**: orchestrazione locale di entrambi i servizi.
4. **k8s-manifest-local.yaml**: manifest Kubernetes per deploy locale in namespace dedicato.
5. **k8s-manifest-aws.yaml**: manifest Kubernetes per deploy su AWS EKS.
6. **k8s-local-deploy.sh**: script bash per deploy su Kubernetes locale.
7. **k8s-aws-deploy.sh**: script bash per deploy su AWS EKS.

## Struttura del repository

```text
├── llm-server/
│   ├── Dockerfile
│   └── README.md            # Documentazione specifica per il server LLM
├── spring-llm/
│   ├── Dockerfile
│   └── README.md            # Documentazione specifica per l'app Spring Boot
├── docker-compose.yaml
├── k8s-manifest-local.yaml
├── k8s-manifest-aws.yaml
├── k8s-local-deploy.sh
├── k8s-aws-deploy.sh
└── .gitignore
```

## Prerequisiti

- Docker & Docker Compose
- Java 21+ e Maven 3.9+
- kubectl
- AWS CLI
- k3d (o altri engine come Minikube/kind/k3s)

## Esecuzione locale con Docker Compose

Dalla radice del repository:

```bash
docker-compose up --build
```

- **llm-server** sarà disponibile su `http://localhost:9090/`
- **spring-llm** sarà disponibile su `http://localhost:8080/`


## Deploy su Kubernetes locale

Per distribuire entrambi i servizi in un cluster Kubernetes, eseguire, dalla radice del repository:

```bash
sh k8s-local-deploy.sh
```

```markdown
**⚠️ AVVISO IMPORTANTE**

Lo script è stato testato solo sull'ambiente Kubernetes **k3d**, ma può essere facilmente adattato a qualsiasi altro Kubernetes locale (es. Minikube).

Nel caso si usi un ambiente Kubernetes diverso da k3d, prima di lanciare lo script, adattare le righe 24-26 del file con i relativi comandi di creazione cluster e import delle immagini docker per l'ambiente Kubernetes locale scelto.
```

Lo script prevede i seguenti passaggi:
1. Build delle immagini docker locali
2. Creazione cluster `demo-llm-cluster` sull'ambiente Kubernetes locale
3. Import delle immagini generate al punto 1 sull'ambiente Kubernetes locale
4. Creazione del namespace k8s `demo-llm`.
5. Applicazione del manifest k8s `k8s-manifest-local.yaml`
6. Port forwarding della porta 80 del cluster sulla porta 8080 locale

- **llm-server** è esposto solo internamente come `ClusterIP` all’indirizzo `llm-server:80`.
- **spring-llm** è esposto esternamente come `LoadBalancer` sulla porta `8080` locale (internamente al cluster sulla porta 80).

## Deploy su AWS EKS

Per distribuire entrambi i servizi su AWS EKS:

1. Avviare la sessione di AWS Learner Lab
2. Creare un cluster EKS da console web AWS chiamato **demo-llm-cluster**
3. Copiare le credenziali AWS CLI fornite dal Learner Lab (tab "AWS Details") nel file __~/.aws/credentials__ della propria macchina personale 
4. Eseguire lo script:
```bash
sh k8s-aws-deploy.sh
```
Verrà richiesto in input l'AWS Account ID e la region (messe a disposizione dal Learner Lab sempre nel tab "AWS Details").

```markdown
**⚠️ AVVISO IMPORTANTE**

Lo script è stato testato solo su macchine Linux. Il comando __envsubst__ non è disponibile su macchine Windows.
```

Lo script prevede i seguenti passaggi:
1. Creazione repository Elastic Container Registry (ECR)
2. Connettere Docker locale con ECR
3. Build e tag delle immagini Docker in locale e successivo push sui repository ECR creati al punto 1
4. Tag delle subnet per la corretta creazione degli Elastic Load Balancers (ELB)
4. Creazione del namespace k8s `demo-llm`.
5. Applicazione del manifest k8s `k8s-manifest-aws.yaml`

## Personalizzazioni

- Modificare l’URL o il percorso del modello nel `Dockerfile` di **llm-server** per usare modelli differenti.
- Regolare le variabili di ambiente e le porte secondo le proprie esigenze.
- Modificare lo script `k8s-local-deploy.sh` a seconda dell'ambiente Kubernetes locale installato