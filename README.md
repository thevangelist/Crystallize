# Crystallize it

## Installation

### Docker
Install docker: http://docs.docker.com/installation/

### Setup
Go to project folder and run setup script:
```
script/setup
```

## Run 
Run the app:
```
script/run
```

## Tests
Tests can be run with the following script:
```
script/test
```

## Deployment
###First deployment:
Clone the repo to server and run `script/deploy cold`. This will build the docker image and start the app.

###Later deployments:
Updates that do not require changes to docker image:
```
script/deploy
```

If updates to docker image are needed.
```
script/deploy cold
```
