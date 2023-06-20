# gogreen
FIT

##http://localhost:8080/swagger/index.html
##http://localhost:8080/api/Event

Add-Migration <MigrationName>
Update-Database

#remove last migration
Remove-Migration

# Paziti!
Remove-Migration -Force

dotnet ef migrations remove <MigrationName>
Update-Database <MigrationName> -Script -SourceMigration $InitialDatabase
Update-Database 20230604154459_UpdateEcoViolationModel-02 -Script -SourceMigration 20230604154459_UpdateEcoViolationModel-02
dotnet ef migrations remove 20230604154459_UpdateEcoViolationModel-02

# Rollback to last migration
dotnet ef database update <PreviousMigrationName>
dotnet ef database update 20230604153803_UpdateEcoViolationModel-Add-Municipality




docker build -t gg-01-gogreen-api:latest .
docker-compose up -d

#docker build -t gg-01-gogreen-api:latest -f GoGreen/Dockerfile .
#docker run -d -p 5672:5672 -p 1572:15672 zec:0.3



ToDO:

Note! XXX - Zamjeniti sa kljucem

1. Kreirati .env file kraj docker-composer i setup vales:

AzureStorage__ConnectionString=DefaultEndpointsProtocol=https;AccountName=rs2storagegogreen;AccountKey=XXX;EndpointSuffix=core.windows.net

// Kako bi docker composer mogao setup values for Cloud Image Service

2. Kreirati u GoGreen file: appsettings.Production.json i setup values:

  "AzureStorage": {
    "ConnectionString": "DefaultEndpointsProtocol=https;AccountName=rs2storagegogreen;AccountKey=XXX;EndpointSuffix=core.windows.net"
  }

  // Kako bi docker composer pokrece env kao Production i ako bi app mogla da ucita values for Cloud Image Service

3. Ako se app pokrece u Development modu na win, na Win System Var setup varijablu sa imenom "AzureStorage__ConnectionString" i values "DefaultEndpointsProtocol=https;AccountName=rs2storagegogreen;AccountKey=XXX;EndpointSuffix=core.windows.net"