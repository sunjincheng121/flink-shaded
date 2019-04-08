#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##
## Variables with defaults (if not overwritten by environment)
##
MVN=${MVN:-mvn}

# fail immediately
set -o errexit
set -o nounset
# print command before executing
set -o xtrace

CURR_DIR=`pwd`
if [[ `basename $CURR_DIR` != "tools" ]] ; then
  echo "You have to call the script from the tools/ dir"
  exit 1
fi

###########################
EXCLUDE_HADOOP_MODULE="-pl !flink-shaded-hadoop-2"

COMMON_OPTIONS="-Prelease -DskipTests -DretryFailedDeploymentCount=10 "

cd ..

echo "Deploying to repository.apache.org"
$MVN clean deploy $COMMON_OPTIONS $EXCLUDE_HADOOP_MODULE

HADOOP_MODULE="-pl flink-shaded-hadoop-2"

HADOOP_VERSIONS=("2.4.1" "2.6.5" "2.7.5" "2.8.3")

for i in "${!HADOOP_VERSIONS[@]}"; do
echo "Deploying flink-shaded-hadoop $HADOOP_VERSIONS[$i] version"
    $MVN clean deploy gs$COMMON_OPTIONS $HADOOP_MODULE "-Dhadoop.version=${HADOOP_VERSIONS[$i]}"
done
