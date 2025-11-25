FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    mariadb-client \
    cron \
    tzdata \
    curl \
    bzip2 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Default ENV from original image
ENV MYSQL_ENV_MYSQL_HOST=mysql
ENV BACKUP_TIME="0 3 * * *"

# Copy scripts
COPY src/docker-entrypoint.sh /entrypoint.sh
COPY src/backup src/restore /bin/

RUN chmod +x /entrypoint.sh /bin/backup /bin/restore

VOLUME /backups

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cron", "-f"]

