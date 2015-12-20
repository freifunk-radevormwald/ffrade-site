#### How to build the Freifunk Radevormwald Firmware (Gluon v2015.2)
    
    git clone https://github.com/freifunk-gluon/gluon.git gluon -b v2015.1.2    # Get the official Gluon repository
    cd gluon
    git clone https://github.com/steneu/ffrade-site.git site                    # Get the Freifunk Mayen-Koblenz site repository
    make update                                                                 # Get other repositories used by Gluon
    make GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable -j4                    # Build Gluon
