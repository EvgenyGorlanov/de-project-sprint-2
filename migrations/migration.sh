pg_dump -h localhost --username jovyan --dbname de --file /lessons/de-project-2/backup/20220916_backup_de.sql;
psql postgresql://jovyan:jovyan@localhost:5432/de < /lessons/de-project-2/migrations/01_shipping_country_rates.sql;
psql postgresql://jovyan:jovyan@localhost:5432/de < /lessons/de-project-2/migrations/02_shipping_agreement.sql;
psql postgresql://jovyan:jovyan@localhost:5432/de < /lessons/de-project-2/migrations/03_shipping_transfer.sql;
psql postgresql://jovyan:jovyan@localhost:5432/de < /lessons/de-project-2/migrations/04_shipping_info.sql;
psql postgresql://jovyan:jovyan@localhost:5432/de < /lessons/de-project-2/migrations/05_shipping_status.sql;
psql postgresql://jovyan:jovyan@localhost:5432/de < /lessons/de-project-2/migrations/06_shipping_datamart.sql;
