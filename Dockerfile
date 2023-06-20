#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Add the installation
RUN apt-get update && apt-get install -y iputils-ping
RUN apt-get update && apt-get install -y iputils-ping telnet

COPY ["GoGreen/GoGreen.csproj", "GoGreen/"]
COPY ["RabbitMQService/RabbitMQ.Service.csproj", "RabbitMQService/"]
#COPY ["GoGreen.Services/GoGreen.Services.csproj", "GoGreen.Services/"]
RUN dotnet restore "GoGreen/GoGreen.csproj"
COPY . .
WORKDIR "/src/GoGreen"
RUN dotnet build "GoGreen.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GoGreen.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GoGreen.dll"]
