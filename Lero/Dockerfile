# Use an Ubuntu or Debian base image
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y build-essential wget curl libreadline-dev zlib1g-dev \
                       flex bison libxml2-dev libxslt-dev libssl-dev \
                       libldap2-dev locales ca-certificates sudo git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set PostgreSQL version as an environment variable
ENV POSTGRES_VERSION=13.1

# Download PostgreSQL source code and extract
RUN wget https://ftp.postgresql.org/pub/source/v$POSTGRES_VERSION/postgresql-$POSTGRES_VERSION.tar.bz2 && \
    tar -xvf postgresql-$POSTGRES_VERSION.tar.bz2 && \
    rm postgresql-$POSTGRES_VERSION.tar.bz2

# Clone the Lero patch repository
RUN git clone https://github.com/AlibabaIncubator/Lero-on-PostgreSQL.git

# Apply the patch from the cloned Lero repository
RUN cd postgresql-$POSTGRES_VERSION && \
    git apply ../Lero-on-PostgreSQL/0001-init-lero.patch

# Build and install PostgreSQL
RUN cd postgresql-$POSTGRES_VERSION && \
    ./configure --prefix=/usr/local/pgsql && \
    make && \
    make install

RUN apt-get update && apt-get install -y python3 python3-pip && \
    pip3 install joblib numpy torch psycopg2-binary

# Create PostgreSQL data directory
RUN mkdir -p /usr/local/pgsql/data

# Create a PostgreSQL user and set permissions
RUN groupadd postgres && \
    useradd -g postgres -s /bin/bash postgres && \
    chown -R postgres:postgres /usr/local/pgsql

# Switch to the postgres user
USER postgres

# Initialize the database
RUN /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data

# Modify PostgreSQL configuration
RUN echo "listen_addresses = '*'" >> /usr/local/pgsql/data/postgresql.conf && \
    echo "geqo = off" >> /usr/local/pgsql/data/postgresql.conf && \
    echo "max_parallel_workers = 0" >> /usr/local/pgsql/data/postgresql.conf && \
    echo "max_parallel_workers_per_gather = 0" >> /usr/local/pgsql/data/postgresql.conf

# Copy the TPC-H .tbl files and the load script into the container
COPY ./DEOL_1gb/*.tbl /usr/local/pgsql/tpch_data/
COPY load_tpch_data.sql /usr/local/pgsql/
COPY schemata.sql /usr/local/pgsql/tpch_data

# Expose PostgreSQL port
EXPOSE 5432
# Start PostgreSQL
CMD ["/bin/bash", "-c", "/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data & sleep 5 && /usr/local/pgsql/bin/psql -U postgres"]

# -d stats -f /Lero-on-PostgreSQL/lero/reproduce/stats_db.sql && /usr/local/pgsql/bin/psql -U postgres