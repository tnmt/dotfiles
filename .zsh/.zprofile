if [ -f /usr/bin/keychain ] ||  [ -f /usr/local/bin/keychain ]
then
keychain id_ed25519
keychain id_rsa
    [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && \
        source $HOME/.keychain/$HOSTNAME-sh
    [[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]] && \
        source  $HOME/.keychain/$HOSTNAME-sh-gpg
fi

arch=`uname -m`
if [ "$arch" = "x86_64" ]; then
    if [ -f /usr/local/bin/brew ]
    then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    if [ -f /opt/homebrew/bin/brew ]
    then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi
