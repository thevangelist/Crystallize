# Formalize it

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
Install following tools:
 * stack
 * wkhtmltopdf

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
Add required info to your `.ssh/config` and make sure you are in
`authorized_keys` file on the server.

To deploy just run:
```
script/deploy
```
