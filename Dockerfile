FROM gliderlabs/alpine:3.6

RUN apk add --no-cache git bash fortune

RUN mkdir /test \
    && cd /test \
    && git init \
    && ln -s /src/pre-receive-hook.sh /test/.git/hooks/pre-receive

ADD . /src

VOLUME ["/src"]

WORKDIR /src

CMD ["/src/pre-receive-hook.sh"]
