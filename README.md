# Jazz Plugin Maven Archetype <br /> Bootstrapping new Jazz Services was never easier!
Maven archetype to generate a jazz plugin project. If you want to get your feet wet as quickly as possible, just read [Bootstrapping](#bootstrapping-a-new-jazz-service-using-this-archetype)<br />
([What is Archetype?](https://maven.apache.org/guides/introduction/introduction-to-archetypes.html))

All of the following sections make assumptions about your working environment. At least git and maven are absolutely necessary to use this archetype. The instructions assume that both executables are on your path and consequently useable with just the program name.

Further, you will need to have installed the [Jazz Base Service](https://github.com/jazz-community/jazz-plugin-base-service), which is a dependency for any services created with this archetype. Any maven builds without this dependency available in your local maven repository will fail. Also, you need to have the [jazz sdk p2 repository](https://github.com/jazz-community/jazz-p2-repository-converter) available in your maven repository. It is also suggested that you have the [Jazz Debug Environment](https://github.com/jazz-community/jazz-debug-environment) available for a rapid development and test cycle.

## Example archetype usage
This section shows how to create an example service from the archetype. It uses default settings and is therefore not recommended for usage in a productive environment without reviewing it carefully. Hence, it only serves as an example.

1. Clone this repository: `git clone https://github.com/jazz-community/jazz-plugin-maven-archetype.git`
2. Run the setup script
    * Windows Powershell: `.\setup.ps1 -g org.siemens.example`
    * Linux: `./setup.sh`
3. Three consecutive successful maven build cycles should run.
4. Inside the target folder, there should now be a folder named `com.siemens.example.parent` with the example service structure.
5. You can now run `mvn package` from inside the `target/com.siemens.example.parent` folder to build the example service plugin.

## Bootstrapping a new jazz service using this archetype
Using paramters when running the automated setup, a new service can be created with proper package declaration, groupId and names already set. Passing the right parameters will allow you to get coding right away. In this example, I will demonstrate how to create a service with the groupId `org.company.example`, a version of `0.0.1-SNAPSHOT` and a service named `GitHubExampleService`.

1. Clone this repository: `git clone https://github.com/jazz-community/jazz-plugin-maven-archetype.git`
2. Run the setup script, but this time passing values to all parameters (chose your own values, short parameters are available):
    * Windows Powershell: `.\setup.ps1 -group org.siemens.example -version 0.0.1-SNAPSHOT -serviceName GitHubExampleService`
    * Linux: `./setup.sh --group com.siemens.example --serviceName GitHubExampleService --version 0.0.1-SNAPSHOT`
3. As above, this will place a plugin folder structure called `org.siemens.example.parent` in the target folder.
4. Copy this folder to wherever you want to work on your plugin.
5. Run `mvn package` to build the plugin files required to run the plugin as a service from this location, or run `mvn install` to make the package available in your maven repository.

## Running tests
To run your unit tests, run `mvn integration-test`. Although the tests are standard junit unit tests, they are run in the integration-test phase because of the tycho-surefire plugin. This makes it possible to use and especially mock many dependencies that would otherwise be unavailable. For a more in-depth look at how you can use this to your advance, look at the tests in the [Base Service project](https://github.com/jazz-community/jazz-plugin-base-service).

Unless you are looking to use special features, you can write your tests like you would any other regular junit unit tests.

### Deploying to Jazz
When deploying to a jazz instance running on an application server, you can deploy the update site created by the maven build like you would any other update site.

1. After a successful maven build, there should be a `target` folder within your `update-site` folder. 

    Example: `com.siemens.example.parent/update-site/target`

    Inside this folder, there will be a zipped update site, eg. `com.siemens.example.updatesite-1.0.0-SNAPSHOT.zip`

2. Extract the `packagename-update-site.ini` **file** from the zip file to the `server/conf/ccm/provision_profiles` directory (where packagename is the package of your service)
3. Extract the `packagename-update-site` **folder** to the `server/conf/ccm/sites` directory (where packagename is the package of your service)
4. Restart the server
5. Once the server has been restarted, your service should be available. You can reach your service under the application it has been deployed with. For example, if you deployed your plugin on ccm, you should find your service on the service description page: `https://server.url/ccm/service`. You can also locate your service directly with it's interface name, such as `https://server.url/ccm/service/com.siemens.example.IExampleService`. Any urls that have been added to the router append to this service url, so if you want to call the `HelloWorldService`, you would call `https://server.url/ccm/service/com.siemens.example.IExampleService/helloWorld`.

### Update existing installation
Whenever you rebuild the plugin after changing your implementation, you will have to redeploy.

1. Request a server reset in one of the following ways:
    * If the server is currently running, call `https://server-address/ccm/admin/cmd/requestReset`
    * Navigate to `https://localhost:9443/ccm/admin?internaltools=true` so you can see the internal tools (on the left in the side-pane). Click on `Server Reset` and press the `Request Server Reset` button
    * If your server is down, you can delete the ccm `built-on.txt` file. Liberty packed with 6.0.3 puts this file in a subfolder of `server/liberty/servers/clm/workarea/org.eclipse.osgi/**/ccm`. The easiest way to locate the file is using your operating system's search capabilites.
2. Delete previously deployed updatesite folder
3. Follow the file extraction steps from the section above
4. Restart the server

### More deployment information
For more information about deploying extensions, check out [Ralph Schoon's blog](https://rsjazz.wordpress.com/2014/06/12/is-the-extension-deployed-how-can-i-redeploy/)

### For jetty
When using jetty with the [Jazz Development Environment](https://github.com/jazz-community/jazz-debug-environment), the `plugin/` and `plugin/target` folders should be used for run-time dynamic lookup. The files edited here should be located in your `debug-environment/conf/jetty/user_configs` folder.

1. Add a property value (or a new file dedicated to just this property) which states which folders your plugin files are in. For the example generated here, it would look like this:
    `org.company.example=target/dependency,target/classes`
2. Add the location of your **plugin** folder to your list of workspaces. It is essential that you reference the plugin folder containing your plugin.xml here. (Windows folder location used as an example).
    `D\:/workspaces/org.company.example.parent/plugin@start`
3. Run the `generate_jetty_config` script.
4. Run jetty
5. After jetty has started, you can verify that your service is running by opening the services page, for example `https://localhost:7443/jazz/service/` and locating your service. You can also call the service directly, for example `https://localhost:7443/jazz/service/org.company.example.IMyService/helloWorld`, which will show a website saying `Hello World!!!`

## Incrementing version
When building and distributing a new version of your service, all of the versions in your pom and manifest.mf files have to match in order for the tycho build to be consistent. Always use the `tycho-versions-plugin` to change the version of your plugin, as it will change all files for you automatically without having to change them manually.

Run the tycho-versions-plugin from the project root (where the root pom.xml is located).

Example, change all versions to 2.0.0: `mvn org.eclipse.tycho:tycho-versions-plugin:set-version "-DnewVersion=2.0.0"`

This also makes sure that the correct snapshot and qualifier strings are set in the respective pom and manifest files.

## Dependency versions
If the versions of your dependencies change, there is no other way than adjusting the pom and manifest.mf files by hand. Make sure that the versions you want to use are consistent across these files, otherwise you will get build errors. Use any text editor to make changes.

This is also necessesary when you add dependencies. Changes have to be made to the pom as well as the manifest.mf files. You can use the existing entries as a guide of how to define dependencies so that maven resolves and copies them to the right places.

Remember to keep your test manifest file up to speed with your plugin manifest file. Your tests will likely use the same dependencies as the implementation.

### Detailed archetype usage
Using the archetype directly without the simple setup wrapper scripts is not recommended and you should only use this if you have a very specific use case. You will have to consider some details without which your resulting project will fail to build.

1. Run `mvn install` from anywhere on your system, where you would like to create a new project.
2. Run `mvn archetype:generate -DarchetypeCatalog=local` to enter interactive mode showing locally installed archetypes (the previous step installed the archetype into your repository)
3. Choose the number corresponding to this archetype.
4. Follow the interactive instructions
5. When completed successfully, your new project will have been generated inside the target folder.

When using this approach, you will have to manually set all versions (in all poms with versions and manifest.mf files) to match so that consecutive builds will run.

For details on the archetype command line, see either the `setup.sh` or the `setup.ps1` files.

## File structure explanation (using the simple example)
For brevity, this section only covers files and folders that are relevant to understanding the basic structure generated by the archetype (not the file structure of the actual archetype). A finished build will contain more files. Files not mentioned here will generally not need to be touched when working on your plugin.

```
com.siemens.example.parent
│ pom.xml                                       Parent pom of the plugin build. This is what you want
|                                               to run most of the time to get a complete plugin build
│
├─.mvn                                          Maven settings folder
│  extensions.xml
│
├─feature                                       Feature module folder
|  |
│  | feature.xml                                Feature configuration with required plugins, feature
|  |                                            description and plugin definition
|  |
│  | pom.xml                                    Sub module pom for creating the plugin feature files
|  |
│  target                                       Generated feature files
|
├─plugin                                        Plugin module folder. Contains the source code of your
| |                                             plugin and is the most important sub module of the
| |                                             plugin project.
| |
│ │ plugin.xml                                  Plugin definition. File used by the application server
| |                                             to load your plugin. Contains the extension point and
| |                                             components used by your plugin to attach to the jazz
| |                                             application. Must contain the proper names of your service.
| |
│ │ pom.xml                                     Sub module pom for creating plugin files
│ │
│ ├─META-INF
│ │  MANIFEST.MF                                OSGI configuration of your plugin. Contains required
│ │                                             bundles and imported packages, as well as the bundle
│ │                                             classpath. This needs to mirror the settings in your
│ │                                             pom and contain all dependencies your plugin builds
│ │                                             against.
│ │
│ |─src                                         Actual plugin source code
│ | └─main
│ |   └─java
│ |     └─com
│ |       └─siemens
│ |         └─example
│ |           │ ExampleService.java             Main service implementation. This file needs to be
| |           |                                 mentioned in the plugin.xml
| |           |                                 
│ |           │ IExampleService.java            Main service interface. This file needs to be mentioned
| |           |                                 in the plugin.xml
│ |           │
│ |           └─builder                         Builder implementations used for the example
│ |              HelloWorldPostService.java     
│ |              HelloWorldService.java
| |
| |─target                                      Generated plugin files. If you are using jetty, your
| |                                             service description will have to point to this location
| |                                             for proper dynamic class loading.
| |
│ └─dependency                                  Dependency jars. If you are using jetty, you wil also
|                                               have to reference this folder.
|
├─test                                          Sub module for unit tests.  
| |
│ │ pom.xml                                     Pom for unit tests
│ │
│ ├─META-INF
│ │  MANIFEST.MF                                OSGI configuration for your tests. Because they are
│ │                                             run in the integration-test phase, make sure that
│ │                                             your unit tests can resolve the same dependencies as
│ │                                             your plugin.
│ │
│ └─src
│   └─test
│     └─java
│       └─com
│         └─siemens
│           └─example
│              ExampleServiceTest.java          Example test. Use this as a starting point to write
│                                               your own tests.
│
└─update-site                                   Update site sub module. This aggregates all build
  |                                             results of the entire project and creates deployable
  |                                             zip files for production use with 
  |                                             tomcat / liberty / websphere. If you use automatic
  |                                             deployment, this should be the source of your packages.
  |                                             
  │ pom.xml                                     Sub module pom for build aggregates.
  |                                             
  ├─target                                      Aggregated build results, contains the deployable plugin.
  |                                             
  └─templates                                   Template xml files that are filtered during the build.
    |                                           These files are neccessary for generating the proper zip 
    |                                           file structure for deploying the plugin on an application
    |                                           server.
    |                                           
    │ site.xml                                  Site descriptor for the loaded feature
    |                                           
    │ update-site.ini                           Update site description with file location and name
    |                                           of the feature to be loaded
    |                                           
    └ zip.xml                                   File structure for resulting plugin update site
```
## Contributing
Please use the [Issue Tracker](https://github.com/jazz-community/jazz-plugin-maven-archetype/issues) of this repository to report issues or suggest enhancements.<br>
Pull requests are very welcome.

## Licensing
Copyright (c) Siemens AG. All rights reserved.<br>
Licensed under the [MIT](https://github.com/jazz-community/jazz-plugin-maven-archetype/blob/master/LICENSE) License.
