# Dokumentation

https://gluon.readthedocs.io/en/v2018.2.x/

Gluon Version auf der die Freifunk Radevormwald Firmware basiert:

* Gluon 2018.2.x

# Download der Firmware

* http://firmware.freifunk-radevormwald.de/

# Firmware selber bauen

1. Vorbereitung:

  1.1 Abhängigkeiten installieren

       sudo apt-get install git subversion build-essential gawk unzip libncurses5-dev zlib1g-dev libssl-dev python

  1.2 Gluon repo clonen

       git clone https://github.com/freifunk-gluon/gluon.git gluon-rdv -b v2018.2.x
       
       
  1.3 Gwünschtes Tag setzen
       
       cd gluon-rdv
       git branch -a 
       git checkout v2018.2.x
       
  1.4 Freifunk Radevormwald Site clonen

       git clone https://github.com/steneu/ffrade-site.git site -b master

2. Firmware bauen

  2.1 Build vorbereiten

       make update

  
  2.2 Anzahl CPU Kerne X ermitteln
  
       X=$(expr $(nproc) + 1)
    
  2.3 Build durchführen für die in Radevormwald gänigen Geräte
  
       X=$(expr $(nproc) + 1) && make -j$X GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable && make -j$X GLUON_TARGET=ar71xx-tiny GLUON_BRANCH=stable && make -j$X GLUON_TARGET=mpc85xx-generic GLUON_BRANCH=stable && make -j$X GLUON_TARGET=x86-generic GLUON_BRANCH=stable && make -j$X GLUON_TARGET=x86-64 GLUON_BRANCH=stable && make -j$X GLUON_TARGET=ramips-mt7621 GLUON_BRANCH=stable && make -j$X GLUON_TARGET=ipq40xx GLUON_BRANCH=stable
       
            
       ## Mögliche Targets

		-ar71xx-generic		(für standard Geräte incl. Fritz!WLAN Repeater 450E)
		-ar71xx-tiny		(für Geräte mit nur 4 MB Flash)
		-ar71xx-nand
		-ipq40xx		(für AVM FRITZ!Box 4040)
		-brcm2708-bcm2708
		-brcm2708-bcm2709
		-mpc85xx-generic	(für tp-link-tl-wdr4900-v1 Geräte)
		-ramips-mt7621		(für Ubiquiti EdgeRouter X)
		-sunxi-cortexa7
		-x86-generic
		-x86-geode
		-x86-64
		-ramips-mt7620
		-ramips-mt76x8
		-ramips-rt305x

       
  2.4 Wenn das Kompilieren fehlschlägt
  
       make -j1 V=s GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable
       
3. Rebuild

  3.1 Updaten

       cd site
       git pull
       cd ..
       git pull
       make update

  3.2 Build Verzeichnis säubern

       make clean GLUON_TARGET=ar71xx-generic

4. Firmware signieren

  4.1 Manifestdatei erstellen
  
      make manifest GLUON_BRANCH=stable
      
  4.2 Manifestdatei signieren
  
      contrib/sign.sh /home/stefan/secret-steneu-ff-sig.key /home/stefan/gluon-rdv/output/images/sysupgrade/stable.manifest
      
      
5. Weitere Infos und Dank an

   5.1 Freifunk Stuttgart - Firmware Signieren
   
       https://wiki.freifunk-stuttgart.net/technik:software:firmware_selbst_kompilieren_und_signieren
       
   5.2 Freifunk Nord - Firmware selbst kompilieren
   
       https://wiki.freifunk.net/Freifunk_Nord/Firmware_selbst_kompilieren
       
