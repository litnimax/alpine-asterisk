# alpine-asterisk
Asterisk alpine docker image

## Building
To reduce image size 2 step building is used.

### Build asterisk from sources and create apk packages
```
docker build -t alpine-asterisk-stage-1 -f Dockerfile.build .
```
Run the mashine:
```
docker run --rm -d --name alpine-asterisk-stage-1 alpine-asterisk-stage-1 sleep 60
```
Now copy packages from container:
```
docker cp alpine-asterisk-stage-1:/home/packager/asterisk/target/packager/x86_64 packages/
```
### Build image using packages
On the 2-nd stage we take apk packages and install them thus keeping the original image small as we don't need all -dev packages.
```
docker build -t litnimax/alpine-asterisk -f Dockerfile .
```

## Settings
See etc/asterisk folder for templates and their settings. Example enabling manager and http:
```
run --rm -it --name asterisk_host -e HTTP_ENABLED=yes -e MANAGER_ENABLED=yes litnimax/alpine-asterisk
```
