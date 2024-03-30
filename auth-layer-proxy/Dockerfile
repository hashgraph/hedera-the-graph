FROM    envoyproxy/envoy:v1.28-latest

# Copy the Filter Scripts
COPY    /filters/ /etc/envoy/filters/
# Copy the Configs templates
COPY    /configs/ /etc/envoy/configs/
# Copy the start script
COPY    /scripts/start-envoy.sh /etc/envoy/start-envoy.sh

# Make the script executable
RUN     chmod +x /etc/envoy/start-envoy.sh
# give ownership to envoy user
RUN     chown -R envoy:envoy /etc/envoy

# install gettext for envsubst
RUN     apt-get update
RUN     apt-get install -y gettext-base

# Install Lua and Luarocks
RUN     apt-get update && apt-get install -y lua5.1 luarocks git

# clean up temp data
RUN     rm -rf /var/lib/apt/lists/*

# Install Lua modules
RUN     luarocks install lua-cjson

# Install http socket module
RUN    luarocks install luasocket
