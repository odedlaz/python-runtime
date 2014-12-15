#
# Python runtime Dockerfile
#
# https://github.com/dockerfile/python-runtime
#

# Pull base image.
FROM dockerfile/python

# Set instructions on build.
ONBUILD RUN virtualenv /env
ONBUILD ADD requirements.txt /app/
ONBUILD ADD apt-requirements.txt /app/
ONBUILD RUN apt-get update && \
  apt-get -y install $(grep -vE "^\s*#" /app/apt-requirements.txt | tr "\n" " ") && \
  rm -rf /var/lib/apt/lists/*
ONBUILD RUN /env/bin/pip install -r /app/requirements.txt
ONBUILD ADD . /app

# Define working directory.
WORKDIR /app

# Define default command.
CMD ["/env/bin/python", "main.py"]

# Expose ports.
EXPOSE 8080
