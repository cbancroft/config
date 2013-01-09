# Mail Configuration #

This mail configuration began from the fantastic guide by Jason Graham
[here]:http://jason.the-graham.com/2011/01/10/email_with_mutt_offlineimap_imapfilter_msmtp_archivemail/

I extended his example to use mutt-kz and notmuch as my MUA.

---

I use the following programs:

+ [offlineimap][]: Syncs mail in local Maildirs with remote IMAP servers.
+ [imapfilter][]: Sorts mail in remote IMAP servers.
+ [mutt-kz][]: Reads the mail.
+ [msmtp][]: Sends new mail.
+ [notmuch][]: Searches and tags mail.
+ [lbdb][]: My local address book.
+ [gnome-keyring][]: To store the credentials for IMAP / SMTP.

[offlineimap]:http://offlineimap.org/
[imapfilter]:https://github.com/lefcha/imapfilter
[mutt-kz]:https://github.com/karelzak/mutt-kz
[msmtp]:http://msmtp.sourceforge.net/
[notmuch]:http://www.notmuchmail.org/
[lbdb]:http://www.spinnaker.de/lbdb/
[gnome-keyring]:https://live.gnome.org/GnomeKeyring
