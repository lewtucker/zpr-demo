FROM ubuntu:22.04

# Set default workdir
WORKDIR /app
COPY bin bin

# Run make in subdirectory
#RUN echo `ls .`
#COPY zpr-policy-go core/zpr-policy-go
#COPY zpr-vsapi-go core/zpr-vsapi-go
##
### Adjust if needed: copy binary to final location
### Example assumes `make` builds a binary named `vservice`
#RUN cp core/build/vservice /bin/vservice
##
### Set up config or other assets
#WORKDIR /app
#COPY config /config

#CMD ["/bin/zpr-visaservice/vservice", "-c", "/config/vs-config.yaml", "-p", "/config/policy.bin"]
