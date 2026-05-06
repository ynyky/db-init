FROM postgres as ccs-base
#to have sysctl
RUN apt update -y && \
    apt install -y \
    procps
ENV WORKDIR /
WORKDIR $WORKDIR

FROM ccs-base as ccs-app-base
RUN mkdir /scripts
ADD ./bin/db_setup /scripts/db_setup
ADD ./bin/memory_max_map_count_setup /scripts/memory_max_map_count_setup

FROM ccs-app-base AS ccs-app-code
COPY bin/ $WORKDIR/bin
