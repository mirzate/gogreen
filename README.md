# gogreen
FIT

##http://localhost:8080/swagger/index.html
##http://localhost:8080/api/Event

------------ TODO -------------------------

Start TODO:

Note! XXX - Zamjeniti sa kljucem

1. Kreirati .env file pored fajla docker-compose.yaml i u njega ubaciti sljedece vrijednosti:

AzureStorage__ConnectionString=DefaultEndpointsProtocol=https;AccountName=rs2storagegogreen;AccountKey=XXX;EndpointSuffix=core.windows.net

// Kako bi docker composer mogao setup values za Image Service koji koristi Cloud Storage.

2. Ukoliko se app pokrece lokalno, kreirati u GoGreen folderu file "appsettings.Production.json" i u njega ubaciti sljedece vrijednosti:

  "AzureStorage": {
    "ConnectionString": "DefaultEndpointsProtocol=https;AccountName=rs2storagegogreen;AccountKey=XXX;EndpointSuffix=core.windows.net"
  }

// Kako bi docker composer kao Production mogao da setup values za Image Service koji koristi Cloud Storage.

3. Ako se app pokrece u Development modu lokalno na windowsu, na Win System Var setup varijablu sa imenom "AzureStorage__ConnectionString" i values "DefaultEndpointsProtocol=https;AccountName=rs2storagegogreen;AccountKey=XXX;EndpointSuffix=core.windows.net"

// Kako bi Image Service mogao da ucita Cloud key za storage.


END TODO:

--------------------------------------------

Help cmd>

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
