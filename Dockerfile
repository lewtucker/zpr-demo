FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
		openssh-client \
    ca-certificates
# ---- Install Rust ----
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# ---- Install Go ----
ENV GO_VERSION=1.22.3
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Confirm versions (optional)
RUN rustc --version && go version

# Set default workdir
WORKDIR /app
COPY . .

WORKDIR /app/zpr-compiler
# Run make in subdirectory
#RUN echo `ls .`
#COPY zpr-policy-go core/zpr-policy-go
#COPY zpr-vsapi-go core/zpr-vsapi-go
RUN make
##
### Adjust if needed: copy binary to final location
### Example assumes `make` builds a binary named `vservice`
#RUN cp core/build/vservice /bin/vservice
##
### Set up config or other assets
#WORKDIR /app
#COPY config /config

#CMD ["/bin/zpr-visaservice/vservice", "-c", "/config/vs-config.yaml", "-p", "/config/policy.bin"]
