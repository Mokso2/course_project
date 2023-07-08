FROM erlang:21-alpine

RUN mkdir /buildroot
WORKDIR /buildroot

COPY erlproj erlproj

WORKDIR erlproj

RUN apk add git
RUN apk add make
RUN rebar3 as prod release

FROM alpine:3.15

ADD erlproj/app/erlproj/c_src/Makefile /files/
ADD erlproj/app/erlproj/c_src/rtpsend.c /files/
ADD erlproj/app/erlproj/c_src/generate.wav /files/

RUN apk add --no-cache make build-base
RUN apk add --no-cache ffmpeg
RUN apk add --no-cache ortp-dev
RUN apk add --no-cache bctoolbox-dev


RUN (cd files/ && make)

COPY --from=0 /buildroot/erlproj/_build/prod/rel/erlproj /erlproj

EXPOSE 8008

CMD ["erlproj/bin/erlproj", "foreground"]