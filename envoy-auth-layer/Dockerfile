FROM    envoyproxy/envoy:v1.28-latest

# Copy the Filter Scripts
COPY /filters/ /filters/

# Install Lua and Luarocks
RUN     apt-get update && apt-get install -y lua5.1 luarocks git

# Install Lua modules
RUN     luarocks install lua-cjson

# Install http socket module
RUN    luarocks install luasocket
