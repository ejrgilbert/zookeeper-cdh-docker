# Zookeeper Image #

This repo houses the code for the Zookeeper Image. It installs zookeeper on
top of the [Datawave Docker-Compose Base image](https://github.com/ejrgilbert/compose-base-image).

# How to... #

## Build the Base Image ##
We have automated the process of building the zookeeper image in the helper script
(`scripts/build.sh`). If you would like to build a new version, simply run:
`./build.sh zookeeper`

To change the CDH version to install, make a new CDH repo file and specify that
version when running the build script, e.g. `./build.sh -c 5.9.1 -- zookeeper`

The script has some different options to enable to runner to tag and push the built
images. Run `./build.sh help` for more information about these options.

The command format must be as follows (the options should always come *before* the
specified command with a `--` delimiting them:
- `./build.sh [<opt1> <opt2> ... --] <cmd>`

## Deploy a new Base Image Version ##
We have a GitLab job that automatically deploys new Devbox versions to the registry
on `master` branch tags. See `.gitlab-ci.yml` for how this is done. However, if you
would like to do it manually (this is not recommended), you will use the build script.

When running `build.sh`, specify the version you would like to tag the image as via the
`-v` option and add the `-p` option as well to tell the script to push the images to the
registry after they have been built.
```bash
./scripts/build.sh -v <ver1> -v <ver2> <ver3> ... -p -- zookeeper
```
