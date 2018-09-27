#!/bin/sh
#

if [ -z "$1" ]; then
	echo "Usage: `basename $0` <Target> [GroupID] [debug]"
else
	 if [ -z "$2" ]; then
		 GroupID='test'
	 else
		 GroupID=$2
	 fi
	 if [ -n "$3" ]; then
		 DEBUG=true
	 fi


# CREDIT: Stole some usage syntax from https://raw.githubusercontent.com/yg-ht/AssortedPenTestStuff/master/ikeVPNmode.sh



# Encryption algorithms: DES, Triple-DES, AES/128, AES/192 and AES/256
ENCLIST="1 5 7/128 7/192 7/256 2 3 4 6 8"
# Hash algorithms: MD5 and SHA1
HASHLIST="1 2 3 4 5 6"
# Authentication methods: Pre-Shared Key, RSA Signatures, Hybrid Mode and XAUTH
AUTHLIST="1 2 3 4 5 64221 65001"
# Diffie-Hellman groups: 1, 2 and 5
GROUPLIST="1 2 5 14 15 19 20"
#
for ENC in $ENCLIST; do
   for HASH in $HASHLIST; do
      for AUTH in $AUTHLIST; do
         for GROUP in $GROUPLIST; do

            # ----- Auth Type
	    if [ "$AUTH" = 1 ]
	    then
		    AUTHNAME="PSK"
	    elif [ "$AUTH" = 2 ]
	    then
		    AUTHNAME="DSS-Sig"
	    elif [ "$AUTH" = 3 ]
	    then
		    AUTHNAME="RSA-Sig"
	    elif [ "$AUTH" = 4 ]
	    then
		    AUTHNAME="RSA-Enc"
	    elif [ "$AUTH" = 5 ]
	    then
		    AUTHNAME="Revised RSA-Sig"
	    elif [ "$AUTH" = 64221 ]
	    then
		    AUTHNAME="Hybrid Mode"
	    elif [ "$AUTH" = 65001 ]
	    then
		    AUTHNAME="XAUTHInitPreShared"
	    else
		    AUTHNAME="Unknown"
	    fi

	    if [ $DEBUG ]; then
	     echo "Auth Type: $AUTHNAME"
    	    fi

            #----- Hash Type

	    if [ "$HASH" = 1 ]
	    then
		    HASHNAME="HMAC-MD5"
	    elif [ "$HASH" = 2 ]
	    then
		    HASHNAME="HMAC-SHA"
	    elif [ "$HASH" = 3 ]
	    then
		    HASHNAME="TIGER"
	    elif [ "$HASH" = 4 ]
	    then
		    HASHNAME="SHA2-256"
	    elif [ "$HASH" = 5 ]
	    then
		    HASHNAME="SHA2-384"
	    elif [ "$HASH" = 6 ]
	    then
		    HASHNAME="SHA2-512"
	    else
		    HASHNAME="Unknown"
	    fi
	    
	    if [ $DEBUG ]; then
	     echo "Hash Type: $HASHNAME"
    	    fi

	    #----- Encryption

            if [ "$ENC" = 1 ]
	    then
		    ENCNAME="DES - WEAK"
	    elif [ "$ENC" = 2 ]
	    then
		    ENCNAME="IDEA - WEAK"
	    elif [ "$ENC" = 3 ]
	    then
		    ENCNAME="Blowfish"
	    elif [ "$ENC" = 4 ]
	    then
		    ENCNAME="RC5-R16-B64"
	    elif [ "$ENC" = 5 ]
	    then
		    ENCNAME="3DES - WEAK"
	    elif [ "$ENC" = 6 ]
	    then
		    ENCNAME="CAST"
	    elif [ "$ENC" = 7 ]
	    then
		    ENCNAME="AES"
	    elif [ "$ENC" = "7/128" ]
	    then
		    ENCNAME="AES-128"
	    elif [ "$ENC" = "7/192" ]
	    then
		    ENCNAME="AES-192"
	    elif [ "$ENC" = "7/128" ]
	    then
		    ENCNAME="AES-256"
	    elif [ "$ENC" = 8 ]
	    then
		    ENCNAME="Camellia"
	    else
		    ENCNAME="Unknown"
	    fi
	    
	    if [ $DEBUG ]; then
	     echo "Encryption: $ENCNAME"
    	    fi

	    #------- Diffie Hellman Group

	    if [ "$GROUP" = 1 ]
            then
		    GROUPNAME="1 - 768-bit MODP group - WEAK"
	    elif [ "$GROUP" = 2 ]
	    then
		    GROUPNAME="2 - 1024-bit MODP group - WEAK"
	    elif [ "$GROUP" = 3 ]
	    then
		    GROUPNAME="3 - EC2N group on GP[2^155]"
	    elif [ "$GROUP" = 4 ]
	    then
		    GROUPNAME="4 - EC2N group on GP[2^185]"
	    elif [ "$GROUP" = 5 ]
	    then
		    GROUPNAME="5 - 1536-bit MODP group"
	    elif [ "$GROUP" = 14 ]
	    then
		    GROUPNAME="14 - 2048-bit group"
	    elif [ "$GROUP" = 15 ]
	    then
		    GROUPNAME="15 - 3072-bit group"
	    elif [ "$GROUP" = 19 ]
	    then
		    GROUPNAME="19 - 256-bit elliptic curve group"
	    elif [ "$GROUP" = 20 ]
	    then
		    GROUPNAME="20 - 384-bit elliptic curve group"
            else
		    GROUPNAME="Unknown"
	    fi
	    
	    if [ $DEBUG ]; then
	     echo "Diffie Hellman Group: $GROUPNAME"
    	    fi

	    #------ Tool Section
	     
            COMMAND="ike-scan -A --trans=$ENC,$HASH,$AUTH,$GROUP $1"
	    if [ $DEBUG ]; then
		    echo "Trying $COMMAND"
	    fi
            ikescan=`ike-scan -A --trans=$ENC,$HASH,$AUTH,$GROUP $1`

	    if [ $DEBUG ]; then
			echo "-------------------"
       	    fi 


            handshake=`echo $ikescan | grep -v "1 returned notify"`
	    if [ -n "$handshake" ]; then
		    echo "DH Group: $GROUPNAME"
		    echo "Encryption: $ENCNAME"
		    echo "Hash Type: $HASHNAME"
		    echo "Auth Type: $AUTHNAME"
		    echo "!!! Handhsake Found with $COMMAND"
	  	    echo "-----------------------------------\n"
	    fi

         done
      done
   done
done
fi
