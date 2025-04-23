# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     appuser

# Switch to the non-privileged user to run the application.
# USER appuser

# build based on Ollama image
FROM python:3.11.9 AS base
# FROM ollama/ollama AS base

### STARTHERE: try to pull/set up LLM model in DockerFile build, not runtime

WORKDIR /app

# RUN ollama serve &

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.cache/pip to speed up subsequent builds.
# Leverage a bind mount to requirements.txt to avoid having to copy them into
# into this layer.
# RUN apt-get update
# RUN apt-get install -y python
# RUN apt-get install -y pip

RUN curl -fsSL https://ollama.com/install.sh | sh

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=./requirements.txt,target=./requirements.txt \
    python -m pip install -r ./requirements.txt

# Copy the source code into the container.
COPY ./entry_point.sh /entry_point.sh
COPY ./graphrag /graphrag
RUN chmod +x /entry_point.sh
RUN chmod +rwx -R /graphrag
RUN chmod +rwx -R /graphrag/output
RUN chmod +rwx -R /graphrag/logs
RUN chmod +rwx -R /graphrag/input
RUN chmod +rwx -R /graphrag/cache
RUN chmod +rwx -R /graphrag/prompts
RUN chmod +rwx /graphrag/.env
RUN chmod +rwx /graphrag/settings.yaml
RUN chmod +rwx /graphrag/input_zip.zip
# RUN unzip /graphrag/input_zip.zip

# Expose the port that the application listens on.
EXPOSE 11434

# Run the application.
# CMD ["/prep_model.sh","python","entry_point.py"]
ENTRYPOINT ["/entry_point.sh"]