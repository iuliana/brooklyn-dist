#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

###############################################################################
fail() {
    echo >&2 "$@"
    exit 1
}

###############################################################################
confirm() {
    # call with a prompt string or use a default
    if [ "${batch_confirm_y}" == "true" ] ; then
        true
    else
      read -r -p "${1:-Are you sure? [y/N]} " response
      case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
      esac
    fi
}

###############################################################################
detect_version() {
    if [ \! -z "${current_version}" ]; then
        return
    fi

    set +e
    current_version=$( xmlstarlet select -t -v '/_:project/_:version/text()' pom.xml 2>/dev/null )
    success=$?
    set -e
    if [ "${success}" -ne 0 -o -z "${current_version}" ]; then
        fail Could not detect version number
    fi
}

###############################################################################
assert_in_project_root() {
    [ -d .git ] || fail Must run in brooklyn project root directory
}

