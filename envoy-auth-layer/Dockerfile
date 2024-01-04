FROM    envoyproxy/envoy:v1.28-latest
# copy envoy.yaml to the container
#COPY envoy.yaml /etc/envoy/envoy.yaml
#RUN chmod go+r /etc/envoy/envoy.yaml

# Install Lua and Luarocks
RUN     apt-get update && apt-get install -y lua5.1 luarocks git

# Install PostgreSQL client and development headers, required for luasql-postgres
RUN     apt-get install -y postgresql-client libpq-dev

# Install Lua modules
RUN     luarocks install lua-cjson
RUN     luarocks install luasql-postgres PGSQL_INCDIR=/usr/include/postgresql/

# Install Redis Lua module
RUN luarocks install redis-lua
