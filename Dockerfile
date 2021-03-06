# Build container
FROM golang:1.9 as builder

RUN go get -u github.com/golang/dep/cmd/dep

WORKDIR /go/src/github.com/msales/kage/
COPY ./ .
RUN dep ensure

RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-s' -o kage ./cmd/kage

# Run container
FROM scratch

COPY --from=builder /go/src/github.com/msales/kage/kage .
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

ENV KAGE_SERVER "true"
ENV KAGE_PORT "80"

EXPOSE 80
CMD ["./kage", "agent"]