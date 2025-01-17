# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container

# Start with a base image and create alias as 'base' for stage 1
FROM golang:1.22.5 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory . Go dependencies are stored in go.mod file
COPY go.mod ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the application . Artifact/binary called 'main' is created in docker image
RUN go build -o main .

#######################################################
# Reduce the docker image size and improve security using distroless image in multi-stage builds
# We will use a distroless image to run the application
# Stage 2 
FROM gcr.io/distroless/base

# Copy the binary from the previous stage . using alias 'base' to default directory
COPY --from=base /app/main .

# Copy the static files from the previous stage . copying the static files which is not bundled with binary
COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]