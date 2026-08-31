FROM mysql:8.0

LABEL maintain="3tierapp-instructor" \
      service="Database" \
      description="MySQL database for 3-tier application" \
      version="1.0" 


ENV MYSQL_ROOT_PASSWORD=root \
    MYSQL_DATABASE=appdb

VOLUME {"/var/lib/mysql"}

COPY init.sql /docker-entrypoint-initdb.d/

EXPOSE 3306

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=5 \
    CMD mysqladmin ping -h localhost -u root -prootpassword || exit 1
