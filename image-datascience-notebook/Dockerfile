# syntax=docker/dockerfile:1

FROM jupyter/datascience-notebook:latest
# Replace `latest` with an image tag from to ensure reproducible builds:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/HEAD/minimal-notebook/Dockerfile

# install additional package...

ADD requirements.txt /usr/local/share/requirements.txt
RUN python -m pip install -r /usr/local/share/requirements.txt
# && \
#    rm -f /usr/local/share/requirements.txt

# set the default command of the image,
# if you want to launch more complex startup than the default `juptyerhub-singleuser`.
# To launch an image's custom CMD instead of the default `jupyterhub-singleuser`
# set `singleuser.cmd: null` in your config.yaml.

WORKDIR "${HOME}"