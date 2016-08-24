#shell fragment

# to be run as user (in /etc/profile.d/

if test -e "$PUAVO_SESSION_PATH"; then
  USER_TYPE=$(cat $PUAVO_SESSION_PATH|jq .user.user_type|sed -e "s/\"//g")
else
  if $(echo $USER| grep -q "guest"); then
     USER_TYPE="student"
  else
     USER_TYPE=""
  fi
fi

if test "$USER_TYPE" = "admin" -o "$USER_TYPE" = "student"; then
    if test -n "$PUAVO_TAG_HTTPFILTER"; then
        echo "starting http filter for user $USER"
        /usr/local/bin/amxa-client-http-filter
    else
        echo "filter not enabled"
    fi
else
   echo "not filtering for group $USER_TYPE"
fi

