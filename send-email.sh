#!/bin/sh

# script expacts email body as file in /tmp/mail-body

EMAIL_SUBJECT="MythTV Server"
FROM_EMAIL_ADDRESS="<email address>"
FRIENDLY_NAME="Your name"
EMAIL_ACCOUNT_PASSWORD="<password>"
TO_EMAIL_ADDRESS="<return email address>"

if [ x$1 = "x" ] ; then
    MESSAGE="Empty Message (as script was called without any parameter)"
else
    EMAIL_SUBJECT="${1}"
    MESSAGE="$@"
fi

if [ -e /tmp/mail-body ] ; then

cat /tmp/mail-body | mailx -v -s "$EMAIL_SUBJECT" \
-S smtp-use-starttls \
-S ssl-verify=ignore \
-S smtp-auth=login \
-S smtp=smtp://smtp.gmail.com:587 \
-S from="$FROM_EMAIL_ADDRESS($FRIENDLY_NAME)" \
-S smtp-auth-user=$FROM_EMAIL_ADDRESS \
-S smtp-auth-password=$EMAIL_ACCOUNT_PASSWORD \
-S ssl-verify=ignore \
$TO_EMAIL_ADDRESS

else

echo $MESSAGE | mailx -v -s "$EMAIL_SUBJECT" \
-S smtp-use-starttls \
-S ssl-verify=ignore \
-S smtp-auth=login \
-S smtp=smtp://smtp.gmail.com:587 \
-S from="$FROM_EMAIL_ADDRESS($FRIENDLY_NAME)" \
-S smtp-auth-user=$FROM_EMAIL_ADDRESS \
-S smtp-auth-password=$EMAIL_ACCOUNT_PASSWORD \
-S ssl-verify=ignore \
$TO_EMAIL_ADDRESS

fi

exit 0
