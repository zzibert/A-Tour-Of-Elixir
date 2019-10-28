FROM elixir:1.9.1-alpine

ENV MIX_ENV=prod

ARG POSTGRES_HOST

ARG POSTGRES_PASSWORD

ARG POSTGRES_DB

ARG POSTGRES_USER

RUN mkdir /opt/app

WORKDIR /opt/app

RUN mix local.hex --force

RUN mix local.rebar --force

COPY mix.* ./

RUN mix deps.get

RUN mix deps.compile

COPY . .

RUN mix compile

RUN MIX_ENV=prod mix release

RUN apk add bash

RUN ["chmod", "+x", "./start.sh"]

ENTRYPOINT ["./start.sh"]

