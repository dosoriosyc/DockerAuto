FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 57461
EXPOSE 44309

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["DockerAuto/DockerAuto.csproj", "DockerAuto/"]
RUN dotnet restore "DockerAuto/DockerAuto.csproj"
COPY . .
WORKDIR "/src/DockerAuto"
RUN dotnet build "DockerAuto.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DockerAuto.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerAuto.dll"]
