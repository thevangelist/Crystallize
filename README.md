# Crystallize it

## Installation

### Docker
Install docker: http://docs.docker.com/installation/

### Docker Setup
Go to project folder and build docker image:
```
docker build -t crystallizer .
```

## Run 
Run the app:
```
sh run.sh
```

## Deployment
###First deployment:

Clone the repo to server and run `sh deploy.sh cold`. This will build the docker image and start the app.

###Later deployments:
Updates that do not require changes to docker image:

Run `sh deploy.sh` on the server in application folder. This will reload the app.

If updates to docker image are needed. Run `sh deploy.sh cold` 
