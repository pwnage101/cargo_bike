FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:freecad-maintainers/freecad-daily && \
    apt-get update && \
    apt-get install -y freecad-daily netgen gmsh python-gmsh git

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/user && \
    echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
    echo "user:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/user

RUN export uid=1000 gid=1000 && \
    mkdir /home/user/.FreeCAD && \
    chown ${uid}:${gid} -R /home/user/.FreeCAD && \
    ln -s /home/user/project/macros /home/user/.FreeCAD/Macro

USER user
ENV HOME /home/user
CMD freecad-daily
