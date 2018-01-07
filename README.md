#### How to build the Freifunk Radevormwald Firmware (Gluon 2017.1.4)
    
    # Get the official Gluon repository
    git clone https://github.com/freifunk-gluon/gluon.git gluon-rdv -b v2017.1.x
    cd gluon-rdv
    git branch -a 
    git checkout v2017.1.4 (gewünschten Tag setzen)
    
    # Get the Freifunk Radevormwald site repository
    git clone https://github.com/freifunk-radevormwald/site.git site
    
    # Get other repositories used by Gluon
    make update
    
    # Build Gluon
    make -j4 GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable
    make -j4 GLUON_TARGET=ar71xx-tiny GLUON_BRANCH=stable       (generic devices, mit nur 4 MB Flash) 
    make -j4 GLUON_TARGET=mpc85xx-generic GLUON_BRANCH=stable
    
    # Im Fehlerfall Build Gluon mit -j1 V=s wiederholden um geneue Infos zum Fehler zu erhalten
    make -j1 V=s GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable
    ... 
    
    # Manifestdatei erstellen
    make manifest GLUON_BRANCH=stable
    
    # Manifestdatei signieren
    contrib/sign.sh /home/stefan/secret-steneu-ff-sig.key /home/stefan/gluon-rdv/output/images/sysupgrade/stable.manifest
    
