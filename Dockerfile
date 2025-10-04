FROM ghcr.io/getzola/zola:v0.21.0 AS zola
COPY . /project
WORKDIR /project
RUN ["zola", "build"]

FROM ghcr.io/static-web-server/static-web-server:2.38.1-alpine
ENV SERVER_HEALTH=true
WORKDIR /
RUN apk --no-cache add curl
COPY --from=zola /project/public /public
HEALTHCHECK \
  --interval=30s \
  --timeout=5s \
  --start-period=5s \
  --retries=3 \
  CMD ["curl", "http://localhost/health"]
