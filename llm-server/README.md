# Demo LLM Server

Questo progetto fornisce un container Docker pronto all'uso per avviare un server basato su `llama.cpp`.
Il container scarica automaticamente un modello GGUF pre-quantizzato e espone un'API HTTP per le chiamate di inferenza.

## Prerequisiti

- Docker

## Esecuzione con Docker

1. Build dell'immagine Docker:
```bash
docker build -t demo-llm-server .
```

2. Avviare il container:

Mappa la porta 8080 del container alla 9090 della macchina locale:

```bash
docker run --rm -p 9090:8080 demo-llm-server
```

Il server sarà disponibile su `http://localhost:9090`.

## Esempio di richiesta

Puoi testare l'API con `curl`:

```bash
curl -X POST \
  http://localhost:9090/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {
        "content": "Ciao",
        "role": "user"
      }
    ]
  }'
```

## Personalizzazioni

- Per usare un modello diverso, è possibile modificare l'URL in `ADD` o caricarne uno locale decommentando il comando `COPY`.
- Se vuoi configurare parametri di inference (temperatura, contesto, ecc.), aggiungi le flag CLI appropriate al `CMD`.