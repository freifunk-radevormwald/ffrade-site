# Dokumentation

https://gluon.readthedocs.io/en/v2019.1.x/

Gluon Version auf der die Freifunk Radevormwald Firmware basiert:

* Gluon 2019.1.2

# Download der Firmware

* http://firmware.freifunk-radevormwald.de/

# Firmware selber bauen

1. Vorbereitung:

  1.1 Abhängigkeiten installieren (Debian 9.12 (Stretch)). Mit Debian 10 funktioniert es vermutlich nicht.
  
  Die Abhängigkeiten müssen als root installiert werden
  
       su <ENTER> Password <ENTER>
       apt-get install git subversion python build-essential gawk unzip libncurses5-dev zlib1g-dev libssl-dev wget time ecdsautils
       
  nach der Installation root mit 'exit' wieder verlassen.
      
  1.2 Gluon repo clonen
  
  Die nachfolgenden Schritte werden als User im Homeverzeichnis durchgeführt!

       git clone https://github.com/freifunk-gluon/gluon.git gluon-rdv -b v2019.1.x
       
       
  1.3 Gewünschtes Tag setzen
       
       cd gluon-rdv
       git branch -a 
       git checkout v2019.1.2
       
  1.4 Freifunk Radevormwald Site clonen

       git clone https://github.com/freifunk-radevormwald/ffrade-site.git site -b master

2. Firmware bauen

  2.1 Build vorbereiten

       make update

  
  2.2 Anzahl CPU Kerne X ermitteln
  
       X=$(expr $(nproc) + 1)
    
  2.3 Build durchführen für die in Radevormwald gänigen Geräte
  
       X=$(expr $(nproc) + 1) && make -j$X GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable && make -j$X GLUON_TARGET=ar71xx-tiny GLUON_BRANCH=stable && make -j$X GLUON_TARGET=mpc85xx-generic GLUON_BRANCH=stable && make -j$X GLUON_TARGET=x86-generic GLUON_BRANCH=stable && make -j$X GLUON_TARGET=x86-64 GLUON_BRANCH=stable && make -j$X GLUON_TARGET=ramips-mt7621 GLUON_BRANCH=stable && make -j$X GLUON_TARGET=ipq40xx GLUON_BRANCH=stable
      
       ## Dem Build-Kommando kann auch noch der Wert von DEFAULT_GLUON_RELEASE mitgegeben
          werden. Dann sieht das Kommando für ein Target z. B. so aus:
       
       X=$(expr $(nproc) + 1) && make -j$X GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable DEFAULT_GLUON_RELEASE=2019.1.2-rdv-1
       
            
       ## Mögliche Targets

          ar71xx-generic        (Standard Geräte incl. Fritz!WLAN Repeater 450E)
          ar71xx-tiny           (Geräte mit nur 4 MB Flash)
          ar71xx-nand
          brcm2708-bcm2708
          brcm2708-bcm2709
          mpc85xx-generic       (tp-link-tl-wdr4900)
          mpc85xx-p1020
          ramips-mt7621         (Ubiquiti EdgeRouter X)
          sunxi-cortexa7
          x86-generic
          x86-geode
          x86-64
          ipq40xx               (AVM FRITZ!Box 4040 und GLi-Net)
          ramips-mt7620
          ramips-mt76x8
          ramips-rt305x
		
	       
  2.4 Ab Gluon 2019.1.x: Patch https://github.com/freifunk-radevormwald/patches einbinden
  
  Damit die Konten auf der Map (HopGlass) angezeigt werden, muss unter 
  gluon-rdv/package/gluon-respondd/files/etc/init.d die Datei gluon-respondd gepatcht werden:
  
 ```
 --- a/package/gluon-respondd/files/etc/init.d/gluon-respondd
+++ b/package/gluon-respondd/files/etc/init.d/gluon-respondd
@@ -13,7 +13,7 @@ start_service() {
        local clientdevs=$(for dev in $(echo "$ifdump" | jsonfilter -e "@.interface[@.interface='$(cat /lib/gluon/respondd/client.dev 2>/dev/null)' && @.up=true].device"); do echo " -i $dev -t $MAXDELAY";done;)

        procd_open_instance
-       procd_set_param command $DAEMON -d /usr/lib/respondd -p 1001 -g ff02::2:1001 $meshdevs -g ff05::2:1001 $clientdevs
+       procd_set_param command $DAEMON -d /usr/lib/respondd -p 1001 -g ff02::1 $clientdevs $meshdevs -g ff05::2:1001 $clientdevs
        procd_set_param respawn ${respawn_threshold:-3600} ${respawn_timeout:-5} ${respawn_retry:-5}
        procd_set_param stderr 1
        procd_close_instance
```
  
  An einer Automation, die beim Build das patchen übernimmt, muss noch gearbeitet werden. Die ./build.sh anderer 
  Communitys habe ich noch nicht durchblickt und mit reinem Clonen auch nicht zum Laufen gebracht. Im Moment wird
  der Build einmal durchlaufen lassen und dann die Datei im entsprechenden Verzeichnis von Hand editiert. Danach
  starte ich ohne "make update" das Ganze noch ein mal.
    
  2.5 Wenn das Kompilieren fehlschlägt
  
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
  
      make manifest GLUON_BRANCH=stable && make manifest GLUON_BRANCH=beta && make manifest GLUON_BRANCH=experimental
      
  4.2 Manifestdatei signieren (ecdsautils muss installiert sein)
  
      contrib/sign.sh /home/stefan/secret-steneu-ff-sig.key /home/stefan/gluon-rdv/output/images/sysupgrade/stable.manifest
      
      
5. Weitere Infos und Dank an

   5.1 Freifunk Stuttgart - Firmware Signieren
   
       https://wiki.freifunk-stuttgart.net/technik:software:firmware_selbst_kompilieren_und_signieren
       
   5.2 Freifunk Nord - Firmware selbst kompilieren
   
       https://wiki.freifunk.net/Freifunk_Nord/Firmware_selbst_kompilieren
       
   5.3 Eulenfunk - Build-Prozess
   
        https://github.com/eulenfunk/firmware
   
   5.4 	Freifunk Hochstift - Build-System
          
       https://git.ffho.net/FreifunkHochstift/ffho-firmware-build
       
