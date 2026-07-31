# Postgres init container: provisions DB roles/databases (bin/db_setup) and
# tunes vm.max_map_count (bin/memory_max_map_count_setup) before the main
# Postgres container starts.
FROM postgres

# procps provides `sysctl`, needed by bin/memory_max_map_count_setup
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends procps && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /scripts
COPY bin/db_setup /scripts/db_setup
COPY bin/memory_max_map_count_setup /scripts/memory_max_map_count_setup
# Also copied onto /bin for any initContainer command that invokes the
# scripts by name instead of by full /scripts path.
COPY bin/ /bin
