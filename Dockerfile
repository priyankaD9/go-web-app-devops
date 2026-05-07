# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container


FROM golang:1.22.5 AS base

WORKDIR /app

COPY go.mod ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o main .

#######################################################
# Reduce the image size using multi-stage builds
# We will use a distroless image to run the application

FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8081

CMD ["./main"]