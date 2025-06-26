FROM ghcr.io/ggml-org/llama.cpp:server

ADD https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf /models/model.gguf
# Alternatively, you can use a local file by uncommenting the next line
# COPY models/my_model.gguf /models/model.gguf

EXPOSE 8080

CMD ["-m", "/models/model.gguf", "--port", "8080", "--host", "0.0.0.0", "-n", "512"]
