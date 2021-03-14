#  --- Build ---
FROM bitwalker/alpine-elixir-phoenix:1.10.3 AS builder
WORKDIR /app
COPY . .
ENV MIX_ENV=prod
RUN mix do deps.get --only prod, deps.compile, phx.digest, release --overwrite

#  --- Run ---
FROM alpine:latest AS runner
RUN apk update && apk --no-cache --update add bash openssl
WORKDIR /app
COPY --from=builder /app/notifications/_build/prod/rel/notifications .

ENTRYPOINT ["bin/notifications"]
CMD ["start"]