#!/bin/sh
# ^ this just sets the shell we are using i.e bash
# ultimately, the positional parameters are what are fed in via the CMD in the dockerfile. This impacts on how the litecoind is ran.

# sets the positional parameters eg $1 $0 
set -e

# if statement to echo $1 and pipe it through 'cut' what I believe is one character and then echo $0's content and assuming arguments for litecoind
if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for litecoind"

# sets positonal parameter of ALL existing postional parameters and close the above if statement
  set -- litecoind "$@"
fi

# Run an if statement doing similar to above, but piping/adding $1 as litecoind, then making a directory using the $LITECOIN_DATA env varaiable, giving r/w/x for user and group
# then echoining out some logging. Then also, making $LITECOIN_DATA owned by litecoin user. We are also echoing the contents of $0 and some other infromation.
if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "litecoind" ]; then
  mkdir -p "$LITECOIN_DATA"
  chmod 770 "$LITECOIN_DATA" || echo "Could notchmod $LITECOIN_DATA (may not have appropriate permissions)"
  chown -R litecoin "$LITECOIN_DATA" || echo "Could notchown $LITECOIN_DATA (may not have appropriate permissions)"

  echo "$0: setting data directory to $LITECOIN_DATA"

# Here we are setting postional parameters of all existing again, whilst adding the datadir of $LITECOIN_DATA
  set -- "$@" -datadir="$LITECOIN_DATA"
fi

# here we are running quite a complex if statement, which ultimately depends on the parameters fed in via the CMD command in the Dockerfile, this will impact on how litecoind will run.
if [ "$(id -u)" = "0" ] && ([ "$1" = "litecoind" ] || [ "$1" = "litecoin-cli" ] || [ "$1" = "litecoin-tx" ]); then
  set -- gosu litecoin "$@"
fi

# here we are executing on the previous set positonal parameters
exec "$@"
