FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

RUN mkdir AzureTableBackupRestore
RUN mkdir data

COPY *.csproj AzureTableBackupRestore/
COPY *.cs AzureTableBackupRestore/
COPY *.json AzureTableBackupRestore/
COPY AzureTableUtilities/src/AzureTableUtilities/*.csproj AzureTableBackupRestore/AzureTableUtilities/src/AzureTableUtilities/
COPY AzureTableUtilities/src/AzureTableUtilities/*.cs AzureTableBackupRestore/AzureTableUtilities/src/AzureTableUtilities/
COPY AzureTableUtilities/src/AzureTableUtilities/*.json AzureTableBackupRestore/AzureTableUtilities/src/AzureTableUtilities/
COPY AzureTableUtilities/src/AzureTableUtilities/Exceptions/*.cs AzureTableBackupRestore/AzureTableUtilities/src/AzureTableUtilities/Exceptions/

RUN dotnet publish AzureTableBackupRestore -c Release -o /app/AzureTableBackupRestore/out

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/AzureTableBackupRestore/out .
ENTRYPOINT ["dotnet", "AzureTableBackupRestore.dll"]