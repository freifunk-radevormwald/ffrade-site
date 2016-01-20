#### How to build the Freifunk Radevormwald beta Firmware (Gluon 2016.1)
    
    # Get the official Gluon repository
    git clone https://github.com/freifunk-gluon/gluon.git gluon -b master
    
    # Get the Freifunk Radevormwald site repository
    cd gluon
    git clone https://github.com/freifunk-radevormwald/site.git site
    
    # Get other repositories used by Gluon
    make update
    
    # Build Gluon
    make -j4 GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable
