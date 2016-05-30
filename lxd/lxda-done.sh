#!/bin/env	bash

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

# build and export image
DIR=$(mktemp -d)
lxc publish $NAME/lxda-build --alias $NAME+$BASE+lxda-build && \
lxc image export $NAME+$BASE+lxda-build $DIR && \
mv $DIR/*.t* ./$NAME+$BASE+lxda-build.t$(echo $DIR/*.t* | rev | cut -d t -f 1 | rev)
rm -rf $DIR
unset DIR

# user config
unset NAME
unset BASE

# LXDA macros
unset RUN
unset END
unset PUSH
unset PULL
unset EXEC

unset -f PUSH
unset -f PULL
unset -f EXEC
