# Use the ASP.NET 6.0 runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MyDatabaseApp.csproj", "./"]
RUN dotnet restore "./MyDatabaseApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MyDatabaseApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyDatabaseApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyDatabaseApp.dll"]

