# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish "eKino/eKino.csproj" -c Release -o /app

# Stage 2: Create the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 7127
EXPOSE 443
ENV ASPNETCORE_URLS=http://+:7127
COPY --from=build /app .
ENTRYPOINT ["dotnet", "eKino.dll"]


