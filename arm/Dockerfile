FROM alpine:latest

LABEL maintainer="XoL <MephistoXoL@gmail.com>" description="Sync 2 WebDav Folders Bidirectionaly" version="arm-v1.08"

## INSTALL PACKAGES
RUN apk add --update --no-cache bash rsync davfs2 tzdata

## CREATING STRUCTURE
RUN mkdir /Folder_Local /Folder_Remote && \
    touch /etc/davfs2/secrets && \
    chmod 600 /etc/davfs2/secrets

## COPY SCRIPTS
COPY unison /usr/bin/unison
COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY Sync_Folders.sh /usr/bin/Sync_Folders.sh

RUN chmod +x /usr/bin/entrypoint.sh /usr/bin/Sync_Folders.sh /usr/bin/unison

ENTRYPOINT /usr/bin/entrypoint.sh
