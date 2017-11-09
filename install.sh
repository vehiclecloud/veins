#!/bin/bash -ev

    mkdir -p $HOME/installs
    pushd $HOME/installs

    sudo apt-get update
    sudo apt-get install -y build-essential gcc g++ bison flex perl tcl-dev tk-dev blt libxml2-dev zlib1g-dev default-jre doxygen graphviz libwebkitgtk-1.0-0 openmpi-bin libopenmpi-dev libpcap-dev autoconf automake libtool libproj-dev libgdal1-dev libfox-1.6-dev libgdal-dev libxerces-c-dev qt4-dev-tools
    sudo apt-get install -y unzip python python-dev
   
    #veins requires 0.30.0 now 
    export SUMO_VERSION=0.30.0
    test -e "sumo-src-$SUMO_VERSION.tar.gz" || wget --quiet http://downloads.sourceforge.net/project/sumo/sumo/version%20$SUMO_VERSION/sumo-src-$SUMO_VERSION.tar.gz
    test -e "sumo-src-$SUMO_VERSION" || tar xzf sumo-src-$SUMO_VERSION.tar.gz
    
    #sumo
    #https://github.com/bogaotory/docker-sumo/blob/master/Dockerfile
    sudo apt-get -qq -y install \
        wget \
        g++ \
        make \
        libxerces-c-dev \
        libfox-1.6-0 libfox-1.6-dev \
        python2.7    
    sudo apt-get -qq -y install \
        libproj-dev  libgdal-dev
    pushd sumo-$SUMO_VERSION
    ./configure
    #make clean
    #make
    #sudo make install
    popd

    #https://hub.docker.com/r/ryankurte/docker-omnetpp/~/dockerfile/
    test -e "omnetpp-5.2-src.tgz" || wget --header="Accept: text/html" \
         --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" \
         --referer="https://omnetpp.org" \
         --output-document=omnetpp-5.2-src.tgz \
         https://omnetpp.org/omnetpp/send/30-omnet-releases/2317-omnetpp-5-2-linux

    test -e "omnetpp-5.2-src" || tar -xf omnetpp-5.2-src.tgz
    pushd omnetpp-5.2

    #omnet
    #https://hub.docker.com/r/ryankurte/docker-omnetpp/~/dockerfile/
    sudo apt-get install -y xvfb
    sudo apt-get install -y osgearth libosgearth-dev
    sudo apt-get install -y \
      qt5-default \
      qt5-qmake \
      qtbase5-dev \
      openscenegraph \
      libopenscenegraph-dev \
      openscenegraph-plugin-osgearth \
      osgearth \
      osgearth-data \
      libosgearth-dev

    xvfb-run ./configure
    export PATH=${HOME}/installs/omnetpp-5.2/bin:$PATH
    #make clean
    make

    #make headless
    #./configure WITH_TKENV=no WITH_QTENV=no WITH_OSG=no
    #make
    popd

    #veins
    test -e "veins-4.6.zip" || wget --quiet http://veins.car2x.org/download/veins-4.6.zip
    test -e "veins-4.6" || unzip veins-4.6.zip
    export PATH=/home/vagrant/omnetpp-5.2/bin:$PATH
    pushd veins-veins-4.6
    ./configure
    make

    #make veins modules
    pushd src
    make
    popd

    popd

