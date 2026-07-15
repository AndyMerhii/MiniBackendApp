# Step 1: Use the official .NET 10.0 SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build-env
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining source files and publish the release
COPY . ./
RUN dotnet publish -c Release -o out

# Step 2: Use the lightweight .NET 10.0 Runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose port 8080 (the default port for .NET containers)
EXPOSE 8080
ENTRYPOINT ["dotnet", "MiniBackendApp.dll"]