#!/bin/bash

# read options, will exit if parameters are malformed
temp=`getopt -n 'setup' -o g:s:v: --long group:,serviceName:,version: -- "$@"`

eval set -- "$temp"

# default parameters
group="org.jazzcommunity.example"
serviceName="ExampleService"
version="1.0.0"

# handle optional parameters
while true; do
    case "$1" in
        -g | --group        ) group="$2";       shift; shift;;
        -s | --serviceName  ) serviceName="$2"; shift; shift;;
        -v | --version      ) version="$2";     shift; shift;;
        --                  )                   shift; break;;
        *                   )                   break;;
    esac
done

mvn clean install

if [ $? -ne 0 ]; then
    echo "Maven failed, check log"
    exit 1
fi

cd target

mvn archetype:generate -B \
    "-DarchetypeCatalog=local" \
    "-DarchetypeGroupId=org.jazzcommunity.service.archetype" \
    "-DarchetypeArtifactId=org.jazzcommunity.service.archetype" \
    "-Dversion=$version" \
    "-DgroupId=$group" \
    "-DartifactId=$group.parent" \
    "-Dpackage=$group" \
    "-DserviceName=$serviceName"

if [ $? -ne 0 ]; then
    echo "Maven failed, check log"
    exit 1
fi

cd "$group.parent"
