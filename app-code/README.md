## Docker File

### Multi-stage Docker File
* In stage 1 , we build docker image using a base image, download dependencies and application is built
* In stage 2 or final stage, use Distroless image as base image. Distroless image reduced image and adds security
* Copy the binary built in stage 1 and expose port and rum application
