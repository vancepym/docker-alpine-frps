FROM alpine:3.15.1 AS builder

ENV FRP_VERSION 0.40.0

RUN wget --no-check-certificate https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz && \ 
    tar xzf frp_${FRP_VERSION}_linux_amd64.tar.gz && chown -R root:root frp_${FRP_VERSION}_linux_amd64 && \
    cd frp_${FRP_VERSION}_linux_amd64 && \
    mkdir /etc/frp && mv frps.ini /etc/frp/frps.ini && \
    mv frps /usr/bin/frps

##########################################################################################
FROM alpine:3.15.1
COPY --from=builder /usr/bin/frps /usr/bin/frps
COPY --from=builder /etc/frp/frps.ini /etc/frp/frps.ini

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && apk upgrade --available && apk add tzdata && \
    cp -a /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

COPY ./docker/aliases.sh /etc/profile.d/
COPY ./docker/docker-entrypoint.sh /run.sh

EXPOSE 7000/tcp

ENTRYPOINT [ "/run.sh" ]
