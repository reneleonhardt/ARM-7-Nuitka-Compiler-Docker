FROM debian:trixie-slim

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      build-essential \
      libffi-dev \
      patchelf \
      patchelf \
      python3-venv \
      python3-dev \
      ccache \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m appuser
USER appuser
WORKDIR /home/appuser

RUN python3 -m venv ~/.venv --system-site-packages \
 && echo 'source /home/appuser/.venv/bin/activate' >> ~/.bashrc
ENV PATH="/home/appuser/.venv/bin:${PATH}"

RUN ~/.venv/bin/pip3 install --no-cache-dir nuitka

WORKDIR /workspace

# Install dependencies if project requirements.txt exist
COPY requirements.txt* .
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# Activate venv when entering shell
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash"]
