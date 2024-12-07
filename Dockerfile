FROM ghcr.io/marco-compiler/marco-prod-debian-12:latest

RUN apt update -y && apt install -y time nano screen
WORKDIR "/root"

ENV PATH="/root/install/marco/bin:/root/install/csv_exporter/bin:$PATH"
ENV SRC_DIR=/data/src
ENV BUILD_DIR=/output/build
ENV LOG_DIR=/output/log
ENV RESULTS_DIR=/output/results
ENV COMPILE_TIMEOUT=7200
ENV SIMULATE_TIMEOUT=7200
