# Zookeeper Image #

This repo houses the code for the Zookeeper Image. It installs zookeeper on
top of the [Datawave Docker-Compose Zookeeper image](https://github.com/ejrgilbert/zookeeper-cdh-docker).

# How to... #

## Build a 5.x Zookeeper Image ##

For 5.x release images, you will just need to change the version at the end of the `baseurl` variable inside
the cloudera-cdh5.repo file. After that, everything else should function as normal.

*MAKE SURE TO UPDATE THE VERSION NUMBERS INSIDE build.sh AT THE TOP*

## Build a 6.x Zookeeper Image ##

(This is only for versions under 6.3.3...after that version you have to authenticate to the endpoint)

Download yum repo from [Cloudera's repo page](https://docs.cloudera.com/documentation/enterprise/6/release-notes/topics/rg_cm_6_version_download.html),
place the download in the zookeeper folder and continue to use `build.sh` as normal. *Make sure to delete the other repo
file so there aren't multiple cdh versions available to yum during the Docker image build.*

*MAKE SURE TO UPDATE THE VERSION NUMBERS INSIDE build.sh AT THE TOP*

## Build the Zookeeper Image ##
We have automated the process of building the zookeeper image in the helper script
(`scripts/build.sh`). If you would like to build a new version, simply run:
`./build.sh`

The script has some different options to enable to runner to tag and push the built
images. Run `./build.sh help` for more information about these options.

## Deploy a new Zookeeper Image Version ##
We have a GitLab job that automatically deploys new Devbox versions to the registry
on `master` branch tags. See `.gitlab-ci.yml` for how this is done. However, if you
would like to do it manually (this is not recommended), you will use the build script.

When running `build.sh`, specify the version you would like to tag the image as via the
`-v` option and add the `-p` option as well to tell the script to push the images to the
registry after they have been built.
```bash
./build.sh -v <ver1> -v <ver2> <ver3> ... -p
```
