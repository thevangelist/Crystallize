FROM google/ruby
MAINTAINER matson

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# copy source to container and install dependencies.
RUN mkdir -p /var/www/app
WORKDIR /var/www/app
ADD . /var/www/app
RUN bundle install

# install and setup PDF generator.
RUN apt-get update && apt-get install -y \
  wkhtmltopdf \
  xvfb
RUN echo -e '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' > /usr/bin/wkhtmltopdf.sh \
  && chmod a+x /usr/bin/wkhtmltopdf.sh \
  && ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf

EXPOSE 8080
CMD ["/bin/sh", "/var/www/app/server.sh"]
