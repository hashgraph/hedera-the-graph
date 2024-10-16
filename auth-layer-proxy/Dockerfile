FROM envoyproxy/envoy:v1.32-latest

# Copy all necessary files
COPY /filters/ /etc/envoy/filters/
COPY /configs/ /etc/envoy/configs/
COPY /scripts/start-envoy.sh /etc/envoy/start-envoy.sh

# Make the start script executable, change ownership, install dependencies, and clean up in a single RUN to reduce layers
RUN chmod +x /etc/envoy/start-envoy.sh && \
    chown -R envoy:envoy /etc/envoy && \
    apt-get update && \
    apt-get install -y gettext-base=0.19.* lua5.1=5.1.* luarocks=2.4.* git=1:2.* libssl-dev=1.1.* && \
    luarocks install lua-cjson && \
    luarocks install luasocket && \
    luarocks install luasec && \
    rm -rf /var/lib/apt/lists/*

# Use the non-root 'envoy' user to run the container
USER envoy
