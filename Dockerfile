FROM golang AS builder

ENV GOPATH /app
RUN mkdir -p /app/src/k8ecr
RUN mkdir /build

ADD Gopkg.lock Gopkg.toml /app/src/k8ecr/

RUN curl -fL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 && \
    chmod +x /usr/local/bin/dep && \
    cd /app/src/k8ecr && \
    dep ensure --vendor-only

ADD . /app/src/k8ecr/
RUN cd /app/src/k8ecr && make && cp k8ecr /build

######

FROM python:3-alpine
ENV AWS_REGION eu-west-2
RUN apk add --no-cache ca-certificates 

COPY --from=builder /build/k8ecr /
ADD autodeploy.py /
RUN pip install requests
CMD ./autodeploy.py
