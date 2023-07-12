FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

RUN apt-get update && apt install tzdata -y
ENV ASPNETCORE_ENVIRONMENT=${DOTNET_ENV}
ENV TZ="Asia/Bangkok"

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["KYCAPI/KYCAPI.csproj", "KYCAPI/"]
RUN dotnet restore "KYCAPI/KYCAPI.csproj"
COPY . .
WORKDIR "/src/KYCAPI"
RUN dotnet build "KYCAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "KYCAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "KYCAPI.dll"]
