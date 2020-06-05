#!/bin/sh

# Temporary set up the nameserver
mv /etc/resolv.conf /etc/resolv2.conf
echo "nameserver 1.1.1.1" > /etc/resolv.conf

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

echo "deb http://repo.ubports.com/ xenial_-_edge_-_android8 main" >> /etc/apt/sources.list.d/ubports.list

echo "" >> /etc/apt/preferences.d/ubports.pref
echo "Package: *" >> /etc/apt/preferences.d/ubports.pref
echo "Pin: origin repo.ubports.com" >> /etc/apt/preferences.d/ubports.pref
echo "Pin: release o=UBports,a=xenial_-_edge_-_android8" >> /etc/apt/preferences.d/ubports.pref
echo "Pin-Priority: 2000" >> /etc/apt/preferences.d/ubports.pref

apt update
apt upgrade -y --allow-downgrades

apt install -y bluebinder ofono-ril-binder-plugin pulseaudio-modules-droid-28
# sensorfw
apt remove -y qtubuntu-sensors
apt install -y libsensorfw-qt5-hybris libsensorfw-qt5-configs libsensorfw-qt5-plugins libqt5sensors5-sensorfw
# hfd-service
apt install -y hfd-service libqt5feedback5-hfd hfd-service-tools
# in-call audio
apt install -y pulseaudio-modules-droid-hidl-28 audiosystem-passthrough

# Media
#ubports-qa install xenial_-_edge_-_android8_-_testing
#apt-get install --reinstall -t xenial_-_edge_-_android8_-_testing gstreamer1.0-hybris
wget https://ci.ubports.com/job/ubports/job/gst-plugins-bad-packaging/job/xenial_-_edge_-_android8_-_testing/2/artifact/gstreamer1.0-hybris_1.8.3-1ubuntu0.3~overlay2_armhf.deb
dpkg -i gstreamer1.0-hybris_1.8.3-1ubuntu0.3~overlay2_armhf.deb
rm gstreamer1.0-hybris_1.8.3-1ubuntu0.3~overlay2_armhf.deb

# Camera
apt-mark hold qtubuntu-android
yes | ubports-qa install xenial_-_gst-droid
apt install -y nemo-qtmultimedia-plugins gstreamer1.0-droid

# custom hfd-service
mkdir -p /root/hfd
wget https://build.lolinet.com/file/hfd/hfd-service-tools_0.1.1_armhf.deb -P /root/hfd/
wget https://build.lolinet.com/file/hfd/hfd-service_0.1.1_armhf.deb -P /root/hfd/
wget https://build.lolinet.com/file/hfd/libqt5feedback5-hfd_0.1.1_armhf.deb -P /root/hfd/
wget https://build.lolinet.com/file/hfd/qml-module-hfd_0.1.1_armhf.deb -P /root/hfd/

dpkg -i /root/hfd/*.deb
rm -rf /root/hfd
apt-mark hold hfd-service-tools hfd-service libqt5feedback5-hfd qml-module-hfd

# custom biometryd
mkdir -p /root/biometryd
wget https://build.lolinet.com/file/biometryd/biometryd-bin_0.0.3+ubports_armhf.deb -P /root/biometryd/
wget https://build.lolinet.com/file/biometryd/libbiometryd1_0.0.3+ubports_armhf.deb -P /root/biometryd/
wget https://build.lolinet.com/file/biometryd/qml-module-biometryd_0.0.3+ubports_armhf.deb -P /root/biometryd/

dpkg -i /root/biometryd/*.deb
rm -rf /root/biometryd
apt-mark hold biometryd-bin libbiometryd1 qml-module-biometryd

# overlay-reader
apt install -y libzip4
mkdir -p /root/overlay-reader
wget https://build.lolinet.com/file/overlay-reader/getoverlay_0.1.0_armhf.deb -P /root/overlay-reader/
wget https://build.lolinet.com/file/overlay-reader/liboverlay-reader_0.1.0_armhf.deb -P /root/overlay-reader/
wget https://build.lolinet.com/file/overlay-reader/liboverlay-reader-dev_0.1.0_armhf.deb -P /root/overlay-reader/

dpkg -i /root/overlay-reader/*.deb
rm -rf /root/overlay-reader

# custom repowerd
mkdir -p /root/repowerd
wget https://build.lolinet.com/file/repowerd/repowerd_2018.04+ubports_armhf.deb -P /root/repowerd/
wget https://build.lolinet.com/file/repowerd/repowerd-data_2018.04+ubports_all.deb -P /root/repowerd/
wget https://build.lolinet.com/file/repowerd/repowerd-tools_2018.04+ubports_armhf.deb -P /root/repowerd/

dpkg -i /root/repowerd/*.deb
rm -rf /root/repowerd
apt-mark hold repowerd repowerd-data repowerd-tools

# qtubuntu-position
mkdir -p /root/qtubuntu-position
wget https://build.lolinet.com/file/qtubuntu-position/qtubuntu-position_0.1%2Bubports_armhf.deb -P /root/qtubuntu-position/

dpkg -i /root/qtubuntu-position/*.deb
rm -rf /root/qtubuntu-position

# Restore symlink
rm /etc/resolv.conf
mv /etc/resolv2.conf /etc/resolv.conf
