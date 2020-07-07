# using prebuilt python docker image as base
FROM python:3.9.0b4-alpine

# set custom root-level directory
WORKDIR /picam

# set env var for picamera lib to work in docker
ENV READTHEDOCS=True

# get requirements for pip
COPY requirements.txt .

# install requirements with pip
RUN pip install -r requirements.txt && \
    pip cache purge

