FROM rust:1.53-buster as builder
RUN apt-get update && apt-get install -y jq

WORKDIR /usr/local/src
COPY Makefile .
RUN make valor
COPY . .
RUN make plugins

FROM debian:buster-slim
#RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/src/out/bin/valor_bin /usr/local/bin/valor
COPY --from=builder /usr/local/src/out/plugins.json /
COPY --from=builder /usr/local/src/out/plugins/* /usr/local/lib/
RUN ldconfig

EXPOSE 8080
ENTRYPOINT ["valor"]
CMD ["-p", "/plugins.json"]
