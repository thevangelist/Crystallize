# Crystallize it

## Installation

### Docker
Install docker: http://docs.docker.com/installation/

### Docker Setup
Add `wkhtmltopdf` to default container:
```
docker run -i -t google/ruby /bin/bash
root@xyz:/# apt-get install wkhtmltopdf
root@xyz:/# apt-get install xvfb
root@xyz:/# echo -e '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' > /usr/bin/wkhtmltopdf.sh
root@xyz:/# chmod a+x /usr/bin/wkhtmltopdf.sh
root@xyz:/# ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf
root@xyz:/# exit
```
Remember your unique commit id (above: xyz):

Commit your changes:
```
docker commit xyz google/ruby:v1
```


## Run 
Install dependencies:

`docker run --rm -v "$(pwd)":/app -w /app google/ruby:v1 sh -c 'bundle install --standalone'`

Run the app:

`docker run -i -t --rm -v "$(pwd)":/app -w /app -p 8080:8080 google/ruby:v1 sh -c 'ruby app.rb'`
