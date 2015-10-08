# Crystallize it

A form which 1) turns answers into a neat PDF & 2) Saves them for later viewing for admins. 
### User scenario
* User scans QR code / arrives to the application via link (in a board game's card)
* User inputs data from her previous gaming session
* After submit, user gets the inputted data in PDF (while saved to server)
### Admin scenario
* Admin arrives to admin UI, inputs username/password
* Admin browses the sent PDF's
* Admin downloads PDF's

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
