# Build stage
FROM docker.io/golang:1.25-alpine AS builder
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
COPY USAGE.txt ./
RUN CGO_ENABLED=0 go build -trimpath -ldflags "-s -w -extldflags=-static" -o fritz-mcp .

# Runtime stage
FROM docker.io/alpine:3.22
RUN adduser -D -H appuser
COPY --from=builder /build/fritz-mcp /usr/local/bin/fritz-mcp
USER appuser
ENTRYPOINT ["fritz-mcp"]
