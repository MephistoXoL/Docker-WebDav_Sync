#!/bin/sh
## File Version v1.07

SYNC_FILE="/usr/bin/Sync_Folders.sh"

# Store Credentials
echo "Storing webdav Credentials"
echo $REMOTE_WEBDAV $REMOTE_USER $REMOTE_PASSWORD >> /etc/davfs2/secrets
echo $LOCAL_WEBDAV $LOCAL_USER $LOCAL_PASSWORD >> /etc/davfs2/secrets

# Mounting WebDav folders
echo "Check mountpoints... "
if [ "$(ls /var/run/mount.davfs/)" ]; then
echo " -  Exist old .pid files removing before Mounting... "
rm -rf /var/run/mount.davfs/*
fi

if [ "$(grep /Folder_Remote /proc/mounts)" ]; then
echo "Already Mounted"
else
echo " -  Mounting /Folder_Remote "
mount -t davfs $REMOTE_WEBDAV /Folder_Remote
mount_exit=$?
    if [ $mount_exit -ne 0 ]; then
        echo "   - Error Mounting, trying to mount again...."
        COUNTER=0
        until [ "$COUNTER" -eq 5 -o "$mount_exit" -eq 0 ]
        do
                mount -t davfs $REMOTE_WEBDAV /Folder_Remote
                mount_exit=$?
                let COUNTER=COUNTER+1
                echo "      Attempt number " $COUNTER
                sleep 5
        done
        if [ $mount_exit -ne 0 ]; then exit 1; fi
    fi
echo "    Done..."
fi

if [ "$(grep /Folder_Local /proc/mounts)" ]; then
echo "Already Mounted"
else
echo " -  Mounting /Folder_Local "
mount -t davfs $LOCAL_WEBDAV /Folder_Local
mount_exit=$?
    if [ $mount_exit -ne 0 ]; then
        echo "   - Error Mounting, trying to mount again...."
        COUNTER=0
        until [ "$COUNTER" -eq 5 -o "$mount_exit" -eq 0 ]
        do
            mount -t davfs $LOCAL_WEBDAV /Folder_Local
            mount_exit=$?
            let COUNTER=COUNTER+1
            echo "      Attempt number " $COUNTER
            sleep 5
        done
        if [ $mount_exit -ne 0 ]; then echo "### Restarting ###" && exit 1; fi
    fi
echo "    Done..."
fi

# Add file extension to Sync_Folder
echo "Checking Extension env. variable... "
if [ -z "$EXTENSION" ]; then
    echo "  · NO extension file applied "
    echo "  · Synchronize all files in folders"
    sed -i 's,'"EXT"','"*"',g' $SYNC_FILE
    sed -i 's,'"INCLUDE"','""',' $SYNC_FILE
    sed -i 's,'"IGNORE"','"-ignore 'Name lost+found'"',' $SYNC_FILE
else
    echo "  · Extension file applied "
    echo "  · Synchronze only .$EXTENSION files"
    sed -i 's,'"EXT"','"*.$EXTENSION"',g' $SYNC_FILE
    sed -i 's,'"INCLUDE"','"-ignorenot 'Name *.$EXTENSION'"',' $SYNC_FILE
    sed -i 's,'"IGNORE"','"-ignore 'Name *.*'"',' $SYNC_FILE
fi
echo "    Done..."

# Set timezone
echo "Set Timezone... "
if [ -z "$TIMEZONE" ]; then
    echo "  · NO timezone applied "
    echo "    Timezone by default"
    apk del tzdata 2>/dev/null
else
    echo "  · Timezone applied - ${TIMEZONE}"
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    echo "${TIMEZONE}" >  /etc/timezone
    apk del tzdata 2>/dev/null
fi
echo "    Done..."    

# Add cronjob
echo "# Adding cronjob and starting..."
if [ -z "$CRON_MINUTES" ]; then
    echo "  · NO Cron Minutes applied "
    echo "  · Run every 3 min."
    echo '*/3 * * * * ' $SYNC_FILE >> /var/spool/cron/crontabs/root
else
    echo "  · Cron Minutes applied "
    echo "  · Run every ${CRON_MINUTES} min."
    echo "*/${CRON_MINUTES} * * * * " $SYNC_FILE >> /var/spool/cron/crontabs/root
fi
echo "    Done... Starting"
crond -l 2 -f
