# gogreen
FIT

Add-Migration <MigrationName>
Update-Database

docker build -t gg-01-gogreen-api:latest .
docker build -t gg-01-gogreen-api:latest -f GoGreen/Dockerfile .
docker run -d -p 5672:5672 -p 1572:15672 zec:0.3
docker-compose up -d


