#!/usr/bin/env	bash

# LXDA - the LXD build DSL
#
# use this one weird trick ops people don't want you to know!
#
# MIT License
#
# Copyright (c) 2016 Haneef Mubarak
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# specify a config
#NAME="lxda-is-dope"
#BASE="ubuntu:16.04"

# let's make a DSL in bash!
RUN="read -d '' RUNCMD << EOF"
END='lxc exec $NAME -- bash -c "$RUNCMD"; unset RUNCMD'

PUSH () {
	lxc file push $1 $NAME/$2/$1
}

PULL () {
	tmp=$(lxc exec $NAME -- basename $1)
	lxc file pull $NAME/$1 $2/$tmp
}

EXEC () {
	lxc exec $NAME -- bash -c "$*"
}

RC () {
	lxc exec $NAME -- sed -i "$*" /root/.bashrc
}

PUSH="PUSH"
PULL="PULL"
EXEC="EXEC"
RC="RC"

# initialization
lxc launch $BASE $NAME

# use fastest (latency, can't measure bandwidth easily) repositories
$RUN
	apt update && \
	apt install -y \
		python-bs4 \
	&& \
	curl https://github.com/jblakeman/apt-select/archive/v0.2.0.tar.gz | \
	tar xzf v0.2.0.tar.gz && \
	cd apt-select-0.2.0 && \
	./apt-select.py -t 5 && \
	mv -v /etc/apt/sources.list /etc/apt/sources.list.backup && \
	mv -v sources.list /etc/apt && \
	cd .. && \
	rm -rf \
		v0.2.0.tar.gz \
		apt-select-0.2.0
EOF
$END
