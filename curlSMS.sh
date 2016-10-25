#!/bin/sh

login="put your line number here (06xxxxxxxx)"
password="put your B and You account password here"
dest="$1"
msg="$2"

cookiesFile="./cookies.txt"

# Fake the user-agent
userAgent="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:48.0) Gecko/20100101 Firefox/48.0"

# Login page
login_url="https://www.mon-compte.bouyguestelecom.fr:443/cas/login"

# Form :
form_url="https://www.secure.bbox.bouyguestelecom.fr/services/SMSIHD/sendSMS.phtml"

# Post to :
submit_url="https://www.secure.bbox.bouyguestelecom.fr/services/SMSIHD/confirmSendSMS.phtml"

# Click Send : (!?)
confirm_url="https://www.secure.bbox.bouyguestelecom.fr/services/SMSIHD/resultSendSMS.phtml"


curl -L -A "$userAgent" \
-H "Accept: text/html" \
-H "Keep-Alive: 300" \
-H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" \
-H "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" \
-H "Accept-Encoding: gzip,deflate" \
-b "$cookiesFile" -c "$cookiesFile" \
-D 0_.log \
-o 0_.html \
"$login_url"

# Grab the Token
lt=$(sed -ne "s/.*name=\"lt\" value=\"\(.[^\"]*\).*/\1/p" 0_.html)

curl -L -A "$userAgent" \
-H "Accept: text/html" \
-H "Keep-Alive: 300" \
-H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" \
-H "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" \
-H "Accept-Encoding: gzip,deflate" \
-b "$cookiesFile" -c "$cookiesFile" \
-d username="$login" -d password="$password" -d _rememberMe=on -d execution=e1s1 -d _eventId=submit -d rememberMe=true -d lt="$lt" \
-D 0_loging.log \
-o 0_loging.html \
--referer "$login_url" \
"$login_url"

curl -L -A "$userAgent" \
-H "Accept: text/html" \
-H "Keep-Alive: 300" \
-H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" \
-H "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" \
-H "Accept-Encoding: gzip,deflate" \
-b "$cookiesFile" -c "$cookiesFile" \
-D 0_form.log \
-o 0_form.html \
--referer "$login_url" \
"$form_url"

curl -L -A "$userAgent" \
-H "Accept: text/html" \
-H "Keep-Alive: 300" \
-H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" \
-H "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" \
-H "Accept-Encoding: gzip,deflate" \
-b "$cookiesFile" -c "$cookiesFile" \
-d fieldMsisdn="$dest" -d Verif.x="42" -d Verif.y="13" -d fieldMessage="$msg" \
-D 1_provisionning.log \
-o 1_provisionning.html \
--referer "$form_url" \
"$submit_url"

curl -L -A "$userAgent" \
-H "Accept: text/html" \
-H "Keep-Alive: 300" \
-H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" \
-H "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" \
-H "Accept-Encoding: gzip,deflate" \
-b "$cookiesFile" -c "$cookiesFile" \
-D 2_send.log \
-o 2_send.html \
--referer "$submit_url" \
"$confirm_url"

exit 0;
