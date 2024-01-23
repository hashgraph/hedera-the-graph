FROM    envoyproxy/envoy:v1.28-latest

# Copy the Filter Scripts
COPY /filters/ /filters/

# Install Lua and Luarocks
RUN     apt-get update && apt-get install -y lua5.1 luarocks git

# Install PostgreSQL client and development headers, required for luasql-postgres
RUN     apt-get install -y postgresql-client libpq-dev

# Install Lua modules
RUN     luarocks install lua-cjson
RUN     luarocks install luasql-postgres PGSQL_INCDIR=/usr/include/postgresql/

RUN     luarocks install sha2
