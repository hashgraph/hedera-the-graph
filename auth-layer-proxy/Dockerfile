FROM envoyproxy/envoy:v1.28-latest

# Copy all necessary files
COPY /filters/ /etc/envoy/filters/
COPY /configs/ /etc/envoy/configs/
COPY /scripts/start-envoy.sh /etc/envoy/start-envoy.sh

# Make the start script executable, change ownership, install dependencies, and clean up in a single RUN to reduce layers
RUN chmod +x /etc/envoy/start-envoy.sh && \
    chown -R envoy:envoy /etc/envoy && \
    apt-get update && \
    apt-get install -y gettext-base lua5.1 luarocks git && \
    luarocks install lua-cjson && \
    luarocks install luasocket && \
    rm -rf /var/lib/apt/lists/*
