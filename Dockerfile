#
# Python runtime Dockerfile
#
# https://github.com/dockerfile/python-runtime
#

# Pull base image.
FROM python:2

# upgrade pip version to latest

ONBUILD	RUN pip install --upgrade pip && \
	export PATH=$PATH:/usr/local/bin

# Set instructions on build.

ONBUILD RUN virtualenv /env
ONBUILD ADD apt-requirements.txt /app/
ONBUILD RUN apt-get update && \
  apt-get -y install $(grep -vE "^\s*#" /app/apt-requirements.txt | tr "\n" " ") && \
  rm -rf /var/lib/apt/lists/*
ONBUILD ADD requirements.txt /app/

# using 'process-dependency-links' for private repo's
# it's deprecated but won't be removed until pip supports
# direct-links, which won't happen soon :)
# further read:  https://github.com/pypa/pip/issues/2023#issuecomment-76086349
ONBUILD RUN /env/bin/pip install --process-dependency-links -r /app/requirements.txt
ONBUILD ADD . /app

# Define working directory.
WORKDIR /app

# Define default command.
CMD ["/env/bin/python", "main.py"]
