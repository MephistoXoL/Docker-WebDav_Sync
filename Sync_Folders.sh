#!/bin/sh
## File Version v1.08
if [ "$(ls /Folder_Local/EXT 2>/dev/null)" ] || [ "$(ls /Folder_Remote/EXT 2>/dev/null)" ]; then
	echo ""
	echo "########################"
	echo "#### Stopping Crond ####"
	sed -i 's/^/#/' /var/spool/cron/crontabs/root
	echo "#### Starting Replica ####"
	echo "#### $(date) ####"
	/usr/bin/unison -batch IGNORE INCLUDE "/Folder_Local/" "/Folder_Remote/"
	echo "#### Replica completed ####"
	echo "#### $(date) ####"
	echo "#### Starting Crond ####"
	sed -i 's/#//' /var/spool/cron/crontabs/root
	echo "#### Completed ####"
	echo "########################"
	echo ""
	echo ""
fi
