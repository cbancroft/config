#!/bin/bash

notmuch new
logger -t offlineimap -p mail.info "Sync of mail account completed"
NEWDIRS=$(find ~/.mail -type f -regex '.*/new/.*' | cut -f5 -d/ | sort -u | tr '\n' ',' | sed -e 's/,/, /g;s/, $//')
if [ -n "$NEWDIRS" ]; then
	notify-send -i /usr/share/notify-osd/icons/hicolor/scalable/status/notification-message-email.svg "New mail in:" "$NEWDIRS"
fi
