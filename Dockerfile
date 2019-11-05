FROM golang:1.13-alpine AS builder
RUN mkdir -p /k8s-event-listener
WORKDIR /k8s-event-listener

RUN apk add -u git curl

COPY go.* ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -o bin/k8s-event-listener

FROM scratch
COPY --from=builder /k8s-event-listener/bin/. .

ENTRYPOINT ["/k8s-event-listener"]