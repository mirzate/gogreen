# gogreen
FIT

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



