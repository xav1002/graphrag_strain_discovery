#!/bin/bash

for entry in "/app"/*
do
  echo "$entry"
done

echo "Starting Ollama server..."
ollama serve &

echo "Waiting for Ollama server to be active..."
while [ "$(ollama list | grep 'NAME')" == "" ]; do
  sleep 1
done

ollama pull llama3.1:8b
ollama pull nomic-embed-text

ollama list

# unzipping txt files
unzip /graphrag/input_zip.zip -d /graphrag/input

python3 -m graphrag prompt-tune --root /graphrag --config /graphrag/settings.yaml --domain 'salt-tolerant microbial species'

python3 -m graphrag index --root /graphrag

python3 -m graphrag query --root /graphrag --method global --query 'Please list salt-tolerant microbial species.'