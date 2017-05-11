param (
    [Alias('g')][string]$group,
    [Alias('v')][string]$version = "1.0.0-SNAPSHOT",
    # maybe make sure that the service name is always
    # capitalized?
    [Alias('s')][string]$serviceName = "ExampleService"
)

if (!$group) {
    echo "Missing argument 'group'."
    exit 1
}

mvn clean install

cd target

# 1.0.0-SNAPSHOT is important here. It needs to be set to this value
# regardless of what is set with the tycho-versions-plugin. OSGI and
# maven at the same time is a bit weird, so just leave this bit of
# magic in here.
mvn archetype:generate -B `
    "-DarchetypeCatalog=local" `
    "-DarchetypeGroupId=com.siemens.bt.jazz.services.archetype" `
    "-DarchetypeArtifactId=com.siemens.bt.jazz.services.archetype" `
    "-Dversion=1.0.0-SNAPSHOT" `
    "-DgroupId=$group" `
    "-DartifactId=$group.parent" `
    "-Dpackage=$group" `
    "-DserviceName=$serviceName"

cd "$group.parent"

mvn org.eclipse.tycho:tycho-versions-plugin:set-version "-DnewVersion=$version"
