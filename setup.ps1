param (
    [string]$group = "com.example.company",
    [string]$version = "1.0.0-SNAPSHOT"
)

mvn clean install

cd target

mvn archetype:generate -B `
    "-DarchetypeCatalog=local" `
    "-DarchetypeGroupId=com.siemens.bt.jazz.services.archetype" `
    "-DarchetypeArtifactId=com.siemens.bt.jazz.services.archetype.parent" `
    "-Dversion=1.0.0-SNAPSHOT" `
    "-DgroupId=$group" `
    "-DartifactId=$group.parent" `
    "-Dpackage=$group"

cd "$group.parent"

mvn org.eclipse.tycho:tycho-versions-plugin:set-version "-DnewVersion=$version"
