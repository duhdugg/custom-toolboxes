# Custom Toolboxes

This repo provides a set of customized base [toolbox
containers](https://github.com/containers/toolbox) using a directory structure that
makes them simple to modify.

## Build

```bash
# bin/build-toolbox [variant] [optional: containername]
# examples
bin/build-toolbox arch
bin/build-toolbox arch-testing
bin/build-toolbox debian
bin/build-toolbox fedora
bin/build-toolbox ubuntu

# this will build an arch toolbox named dev-toolbox (instead of arch-toolbox)
bin/build-toolbox arch dev-toolbox
```

## Enter

```bash
# toolbox enter [containername]
toolbox enter arch-toolbox
toolbox enter arch-testing-toolbox
toolbox enter debian-toolbox
toolbox enter fedora-toolbox
toolbox enter ubuntu-toolbox
toolbox enter dev-toolbox
```

## Variant Directory Structure

- 📂 `variant-name`
  - 📄 `Containerfile`: for building the OCI container
  - 📂 `fs`: everything under here is added to the root filesystem within the container
    - 📂 `build`
      - 📄 `install.sh`: installation script
      - 📄 `toolbox-dependencies`: minimum additional packages required
      - 📄 `extra-packages`: everything else you want installed should go in here
    - 📂 `etc`
      - 📂 `sudoers.d`
        - 📄 `toolbox`: should allow users in wheel group to use sudo with no password

## Troubleshooting

### X11 apps not working

When attempting to run an X11 application from within the toolbox, you may get the
following error:

```text
Authorization required, but no authorization protocol specified
Error: Can't open display: :0
```

To fix this, you can use
[xorg-xauth](https://www.x.org/releases/X11R7.7/doc/man/man1/xauth.1.xhtml) (on your
host machine) to give your container permission to communicate with X11. Run the
following, or add it to your X startup:

```bash
xauth add "toolbox/unix$DISPLAY" . "$(xauth list | grep "^$(hostname)/unix$DISPLAY\s*MIT-MAGIC-COOKIE-1\s*" | awk '{print $3}')"
```

### toolbox enter not working

You may be able to debug with:

```bash
podman stop -a # stops all containers
# podman start --atach [containername]
podman start --attach arch-toolbox
```
