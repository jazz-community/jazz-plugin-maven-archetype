param (
    [Alias('g')][string]$group,
    [Alias('v')][string]$version = "1.0.0",
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

mvn archetype:generate -B `
    "-DarchetypeCatalog=local" `
    "-DarchetypeGroupId=org.jazzcommunity.service.archetype" `
    "-DarchetypeArtifactId=org.jazzcommunity.service.archetype" `
    "-Dversion=$version" `
    "-DgroupId=$group" `
    "-DartifactId=$group.parent" `
    "-Dpackage=$group" `
    "-DserviceName=$serviceName"

cd "$group.parent"
