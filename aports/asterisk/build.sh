sudo chown -R packager.packager /home/packager/asterisk && \
cd /home/packager/asterisk && \
mkdir -p target && \
abuild-keygen -n -a -i && \
abuild checksum && \
abuild -K -r -P /home/packager/asterisk/target && \
cd /home/packager/asterisk/target/packager/x86_64/ && \
apk index -o APKINDEX.tar.gz *.apk && \
abuild-sign APKINDEX.tar.gz && \
sudo apk add asterisk-15.1.5-r0.apk asterisk-odbc-15.1.5-r0.apk asterisk-sample-config-15.1.5-r0.apk asterisk-sounds-en-15.1.5-r0.apk asterisk-sounds-moh-15.1.5-r0.apk asterisk-srtp-15.1.5-r0.apk && \
rm -rf /home/packager/asterisk/src && \
rm -rf /home/packager/asterisk/pkg
