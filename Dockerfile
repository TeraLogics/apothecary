FROM hexpm/elixir:1.12.1-erlang-24.0.2-alpine-3.13.3 AS build

# Install npm
RUN apk add --update npm

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force 

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config/config.exs config/prod.exs config/runtime.exs ./config/
RUN mix do deps.get --only prod, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM hexpm/elixir:1.12.1-erlang-24.0.2-alpine-3.13.3 AS app
RUN apk add --no-cache openssl ncurses-libs npm git

WORKDIR /app

RUN addgroup -S apothecary && adduser -S apothecary -G apothecary && \
    chown apothecary:apothecary /app

USER apothecary

COPY --from=build --chown=apothecary:apothecary /app/_build/prod/rel/apothecary ./

ENV HOME=/app

RUN mix local.hex --force

CMD ["bin/apothecary", "start"]
