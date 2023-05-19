
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 8085
EXPOSE 443


# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "./GoGreen.csproj" --disable-parallel
RUN dotnet build "./GoGreen.csproj" -c Release -o /app/build --no-restore

# Publish Stage
FROM build AS publish
RUN dotnet publish "./GoGreen.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GoGreen.dll"]