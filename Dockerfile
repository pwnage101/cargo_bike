FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:freecad-maintainers/freecad-daily

# Replace 1000 with your HOST user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/user && \
    echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
    echo "user:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/user

# Prep the FreeCAD Macro directory so we can access macros stored in this repo.
RUN export uid=1000 gid=1000 && \
    mkdir /home/user/.FreeCAD && \
    chown ${uid}:${gid} -R /home/user/.FreeCAD && \
    ln -s /home/user/project/macros /home/user/.FreeCAD/Macro

# This breaks the Docker cache, so all subsequent RUN commands will get
# executed on the next `docker build`.
ARG CACHE_DATE=2016-01-01

RUN apt-get update && \
    apt-get install -y freecad-daily netgen gmsh python-gmsh git

USER user
ENV HOME /home/user
CMD freecad-daily
