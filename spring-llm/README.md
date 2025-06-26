# Demo LLM Spring Boot Application

Questo repository contiene un'applicazione Spring Boot che espone due endpoint REST per interagire con un servizio LLM:

## Endpoints

- **GET** `/llm/chat?message=<testo>`  
  Restituisce una stringa:
  ```text
  <testo>
  ```
- **POST** `/llm/chat`  
  Richiede un body JSON:
  ```json
  { "message": "<richiesta>" }
  ```
  e restituisce:
  ```json
  { "message": "<risposta>" }
  ```

## Prerequisiti

- Java 21+  
- Maven 3.9+  
- Docker (opzionale)

## Esecuzione in Locale

1. Clonare il repository:
   ```bash
   git clone https://github.com/Wornairz/Demo-LLM.git
   cd demo-llm/llm-spring
   ```
2. (opzionale) Configurare l'URL del LLM server modificando `src/main/resources/application.properties`:
   ```properties
   llm.api.base-url=http://localhost:1234
   ```
   oppure tramite variabile d'ambiente:
   ```bash
   LLM_API_BASE_URL=http://localhost:1234
   ```
3. Buildare l'applicazione:
   ```bash
   mvn clean package
   ```
4. Eseguire l'app:
   ```bash
   java -jar target/demo-spring-llm-*.jar
   ```
5. Test degli endpoint:
   - GET:
     ```bash
     curl "http://localhost:8080/llm/chat?message=ciao"
     ```
   - POST:
     ```bash
     curl -X POST http://localhost:8080/llm/chat \
       -H "Content-Type: application/json" \
       -d '{"message" : "Ciao! Come va?"}'
     ```

## 2. Esecuzione con Docker

1. Build dell'immagine Docker:
   ```bash
   docker build -t demo-spring-llm:latest .
   ```
2. Avviare il container:
   ```bash
   docker run --rm -p 8080:8080 \
     -e LLM_API_BASE_URL=http://localhost:1234 \
     demo-spring-llm:latest
   ```
3. Verifica degli endpoint ripetendo i comandi `curl` visti in precedenza.

## 3. Struttura del Progetto

```
src/
├── main/
│   ├── java/it/unict/sc/demollm/
│   │   ├── controller/LLMController.java
│   │   ├── service/LLMService.java
│   │   └── dto/LLMRequest.java, LLMResponse.java
│   └── resources/
│       └── application.properties
├── test/
└── Dockerfile
```