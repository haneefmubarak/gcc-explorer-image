#!/bin/env	bash

# config
NAME="gcc-explorer"
BASE="ubuntu:14.04"

# LXDA will setup our container
source ../lxda-init.sh

# latest development tools
$EXEC	add-apt-repository -y ppa:ubuntu-toolchain-r/test

# INSTALL ALL THE PACKAGES!
$RUN
	apt-get -y update && \
	apt-get install -y \
		python-software-properties \
		software-properties-common \
		libc6-dev-i386 \
		libboost-all-dev \
		linux-libc-dev \
		curl \
		git \
		make \
		s3cmd \
		clang-3.5 \
		gcc \
		g++ \
		g++-4.8 \
		g++-4.9 \
		g++-4.8-powerpc-linux-gnu \
		g++-arm-linux-gnueabihf \
		g++-aarch64-linux-gnu \
		tcc
EOF
$END

# NodeJS v4.2.3 x64
$RUN
	mkdir -p /opt && \
	cd /opt && \
	curl "https://nodejs.org/dist/v4.2.3/node-v4.2.3-linux-x64.tar.gz" | \
	tar zxf - && \
	mv node-v4.2.3-linux-x64 node
EOF
$END

# ssh keys
$EXEC	mkdir -pv /root/.ssh
$PUSH	.s3cfg /root
$PUSH	known_hosts /root/.ssh
$PUSH	compilers.sh /root
$EXEC	/root/compilers.sh

# cleanup random ass shit that we don't need
$EXEC	rm /root/compilers.sh
$EXEC	rm /root/.s3cfg
$EXEC	apt-get purge -y curl s3cmd 'openjdk*'
$EXEC	apt full-upgrade -y
$EXEC	apt-get autoremove -y
$EXEC	apt-get clean
$EXEC	'rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/*'

# multiarch woes workaround
$EXEC	ln -s /usr/include/asm-generic /usr/include/asm

# setup user
$RUN
	useradd gcc-user && \
	mkdir -p /gcc-explorer /home/gcc-user && \
	chown gcc-user /gcc-explorer && \
	chown gcc-user /home/gcc-user
EOF
$END
$RC	'HOME=/home/gcc-user'
$RC	'PATH=/opt/node/bin:$PATH'
$PUSH	package.json /tmp/
$EXEC	'su gcc-user bash -c "cd /tmp; env PATH=/opt/node/bin:$PATH npm install"'
$PUSH	run.sh /

# build image and cleanup environment
exec ../lxda-done.sh
