#!/bin/bash
# Copyright 2013 Johan Rydberg.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

HEAD=${1:-HEAD}
VERSION=$(git describe --tags --always)
PORT=${PORT:-9000}
INSTALLDIR=${INSTALLDIR:-/opt/gilliam/hypervisor}
TOPDIR=$(pwd)
BUILDDIR=${TOPDIR}/build

set -x

rm -rf ${BUILDDIR} && mkdir -p ${BUILDDIR}/${INSTALLDIR}
git archive --format=tar ${HEAD} | tar -C ${BUILDDIR}/${INSTALLDIR} -xf -

cd ${BUILDDIR}/${INSTALLDIR}
virtualenv .
./bin/pip install --use-mirrors -r requirements.txt
for SCRIPT in bin/*; do
  sed -i -e "s:#\!.*python$:#\!${INSTALLDIR}/bin/python:" $SCRIPT
done

cd ${BUILDDIR}
mkdir -p etc/init etc/default
cp ${TOPDIR}/pkg/gilliam-hypervisor.conf etc/init/
# FIXME(jrydberg): for some reason the default file is empty from time
# to time. copy over the original.
cp ${TOPDIR}/.env etc/default/gilliam-hypervisor

cd ${TOPDIR}
fpm -s dir -t deb -n gilliam-hypervisor -v ${VERSION} -d lxc -C ${BUILDDIR} .
