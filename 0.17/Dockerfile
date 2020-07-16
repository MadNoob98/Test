# Uses debian stable-slim image as the 'base image'
FROM debian:stable-slim

# just the information on the maintainers/owners of the code
LABEL maintainer.0="João Fonseca (@joaopaulofonseca)" \
  maintainer.1="Pedro Branco (@pedrobranco)" \
  maintainer.2="Rui Marinho (@ruimarinho)"

# Adds a user named litecoin, updates locally stored package information (doesn't upgrade installed packages), installs curl and gnupg and cleans.
# this just cleans local repository of downloaded package files. To save some disk space and make things tidier.
# we are then deleting the /var/lib/apt/lists directories contents, cleaning everything out of /tmp and then setting an environement variable called
# key, for each of the key servers below. This is used to encrypt data end to end and make sure we are getting what we should be, instead of being
# at risk to attacks such as man in the middle attacks and also, verify that the siganture of the package we pulled down actually matches.
RUN useradd -r litecoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex \
  && for key in \
    B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    FE3348877809386C \
  ; do \
    gpg --no-tty --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --no-tty --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --no-tty --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --no-tty --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done

# Here we are setting the environemental variable of GOSU_VERSION to 1.10
ENV GOSU_VERSION=1.10

# Here we are running a curl to pull down gosu and gosu.asc (signature file) from github, to the /usr/local/bin folder, using our env variable to set the version
# package manager to verify the architecture of what we are pulling down. We are also using GPG verify to verify that we have pulled down a safe/
# verfied package, which is checking against signature and package we pulled down.
 
RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

# Here we are setting environmental variables for the litecoin version and also setting one for the 'litecoin data' directory, which is in /home/litec# oin/.litecoin
ENV LITECOIN_VERSION=0.17.1
ENV LITECOIN_DATA=/home/litecoin/.litecoin

# here we are running a curl to download the litecoin tar file/folder and also a curl to download the signature file, we are then using gpg verify to # make sure that we are again, pulling down a safe and verified package. We are then running a tar -xzf to untar our zipped package and sig.
# we are then removing the tar files as to save disk space (we won't need this after unzipping anyway)
RUN curl -O https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && curl https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux-signatures.asc | gpg --verify - \
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz

# Here we are simply copying our entrypoint bash/shell script, to /entrypoint.sh inside of the container.
COPY docker-entrypoint.sh /entrypoint.sh

# Here we are mounting a volume under /home/litecoin/.litecoin (our data directory), however, to not overcomplicated things/we will not need persisten# data for the test, I have left this hashed out. In a production environment/non test environment, we would probably keep this for persistent data.
#VOLUME ["/home/litecoin/.litecoin"]

# Here we are exposing ports 9332, 9333, 19332, 19333 and 19444, these are not 'dangerous' ports to expose, however, it is quite an amount to expose.
EXPOSE 9332 9333 19332 19333 19444

# Here are specifying the 'entrypoint' script location (basically the startup script for this container)'s location.
ENTRYPOINT ["/entrypoint.sh"]

# Sets the default command to be ran at startup, this can however, be overwritten from the command line if need be.
CMD ["litecoind"]

# And that's it! :D 
