#!/bin/bash 
 
# Default Variable Declarations 
DEFAULT="client.conf" 
FILEEXT=".ovpn" 
CRT=".crt" 
KEY=".key" 
CA="ca.crt" 
TA="ta.key" 
CERTLOCATION="/etc/openvpn/easy-rsa/keys/"
MOVPNLOCATION="/etc/openvpn/easy-rsa/movpn/"

#Ask for a Client name 
echo "Please enter an existing Client Name:"
read NAME 
 
 
#1st Verify that client’s Public Key Exists 
if [ ! -f $CERTLOCATION$NAME$CRT ]; then 
 echo "[ERROR]: Client Public Key Certificate not found: $NAME$CRT" 
 exit 
fi 
echo "Client’s cert found: $NAME$CR" 
 
 
#Then, verify that there is a private key for that client 
if [ ! -f $CERTLOCATION$NAME$KEY ]; then 
 echo "[ERROR]: Client 3des Private Key not found: $NAME$KEY" 
 exit 
fi 
echo "Client’s Private Key found: $NAME$KEY"

#Confirm the CA public key exists 
if [ ! -f $CERTLOCATION$CA ]; then 
 echo "[ERROR]: CA Public Key not found: $CA" 
 exit 
fi 
echo "CA public Key found: $CA" 

#Confirm the tls-auth ta key file exists 
if [ ! -f $CERTLOCATION$TA ]; then 
 echo "[ERROR]: tls-auth Key not found: $TA" 
 exit 
fi 
echo "tls-auth Private Key found: $TA" 
 
#Ready to make a new .opvn file - Start by populating with the default file
cat $MOVPNLOCATION$DEFAULT > $MOVPNLOCATION$NAME$FILEEXT 
 
#Now, append the CA Public Cert 
echo "<ca>" >> $MOVPNLOCATION$NAME$FILEEXT 
cat $CERTLOCATION$CA >> $MOVPNLOCATION$NAME$FILEEXT 
echo "</ca>" >> $MOVPNLOCATION$NAME$FILEEXT

#Next append the client Public Cert 
echo "<cert>" >> $MOVPNLOCATION$NAME$FILEEXT 
cat $CERTLOCATION$NAME$CRT | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' >> $MOVPNLOCATION$NAME$FILEEXT 
echo "</cert>" >> $MOVPNLOCATION$NAME$FILEEXT 
 
#Then, append the client Private Key 
echo "<key>" >> $MOVPNLOCATION$NAME$FILEEXT 
cat $CERTLOCATION$NAME$KEY >> $MOVPNLOCATION$NAME$FILEEXT 
echo "</key>" >> $MOVPNLOCATION$NAME$FILEEXT 
 
#Finally, append the TA Private Key 
echo "<tls-auth>" >> $MOVPNLOCATION$NAME$FILEEXT 
cat $CERTLOCATION$TA >> $MOVPNLOCATION$NAME$FILEEXT 
echo "</tls-auth>" >> $MOVPNLOCATION$NAME$FILEEXT 
 
echo "Done! $MOVPNLOCATION$NAME$FILEEXT Successfully Created."

#Script written by Eric Jodoin
No newline at end of file
