FROM ruby

MAINTAINER Andrew Evans (Hired, Inc)

RUN useradd -u 9000 -r -s /bin/false app 

WORKDIR /code
COPY . /usr/src/app

USER app
VOLUME /code

CMD ["/usr/src/app/bin/oops"]
