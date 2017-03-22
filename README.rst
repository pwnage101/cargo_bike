Documentation
=============

See wiki: https://wiki.sankey.info/index.php?title=Cargo_bike

Software
========

Debian 8 (jessie)
-----------------

* Obtain the `docker.io` package from jessie-backports.
* Add your user to the docker group: `sudo addgroup ${USER} docker`
* Build the docker image: `make build-image`
