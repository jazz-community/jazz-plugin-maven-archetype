#!/bin/bash

# read options, will exit if parameters are malformed
temp=`getopt -n 'setup' -o g:s:v: --long group:,serviceName:,version: -- "$@"`

eval set -- "$temp"

# default parameters
group="com.siemens.example"
serviceName="ExampleService"
version="1.0.0-SNAPSHOT"

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
    "-DarchetypeGroupId=com.siemens.bt.jazz.services.archetype" \
    "-DarchetypeArtifactId=com.siemens.bt.jazz.services.archetype" \
    "-Dversion=1.0.0-SNAPSHOT" \
    "-DgroupId=$group" \
    "-DartifactId=$group.parent" \
    "-Dpackage=$group" \
    "-DserviceName=$serviceName"

if [ $? -ne 0 ]; then
    echo "Maven failed, check log"
    exit 1
fi

cd "$group.parent"

mvn org.eclipse.tycho:tycho-versions-plugin:set-version "-DnewVersion=$version"
