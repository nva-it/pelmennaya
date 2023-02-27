FROM golang:1.20.0-bullseye AS builder
ARG VERSION=${VERSION}
ENV GOOS linux
ENV CGO_ENABLED 0
WORKDIR /app/src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o backend-${VERSION} ./cmd/api

FROM scratch as production
ARG VERSION=${VERSION}
WORKDIR /app
COPY --from=builder /app/src/backend-${VERSION} ./backend
EXPOSE 8081
CMD [ "./backend" ]
