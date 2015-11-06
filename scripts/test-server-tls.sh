#!/usr/bin/env bash

set -u
set -o pipefail

usage() {
    echo "usage: $(basename $0) SERVER[:PORT] [PAUSE]"
    echo
    echo "Check supported SSL/TLS ciphers of given server."
    echo
    echo "Parameters"
    echo
    echo "  SERVER: hostname of server to check (e.g., example.com)"
    echo "  PORT: TLS/SSL port (defaults to 443)"
    echo "  PAUSE: seconds to pause between requests (default to 1)"
    echo
    echo "Environment Variables"
    echo
    echo "  OPENSSL_BIN: path to openssl binary to use for checks"
    echo "               (defaults to libressl/openssl in"
    echo "               /opt/{libressl,openssl}/default/bin if found"
    echo "               or first 'openssl' on PATH"
}

if [[ -z "${1:-}" || "${1:-}" = "-h" ]]; then
    usage
    exit 1
fi

SERVER="$1"
if [[ ! "${SERVER}" =~ ":" ]]; then
    SERVER="${SERVER}:443"
fi
PAUSE="${2:-1}"

OPENSSL_BIN="${OPENSSL_BIN:-}"

# If no OPENSSL_BIN explicitly set, then prefer custom libressl/openssl in /opt
# for determining ciphers to check, or use first openssl on PATH as last resort.
if [[ -z "${OPENSSL_BIN:-}" ]]; then
    for lib in libressl openssl; do
        exe="/opt/${lib}/default/bin/openssl"
        if [[ -x "${exe}" ]]; then
            OPENSSL_BIN="${exe}"
            break
        fi
    done
    if [[ -z "${OPENSSL_BIN:-}" ]]; then
        OPENSSL_BIN=$(which openssl)
    fi
fi

ciphers=$(${OPENSSL_BIN} ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo "Getting cipher list from \"$(${OPENSSL_BIN} version)\" using \"${OPENSSL_BIN}\""

for cipher in ${ciphers[@]}; do
    result=$(echo -n | ${OPENSSL_BIN} s_client -cipher "${cipher}" -connect ${SERVER} 2>&1 | tr '\n'  ' ')
    if [[ "${result}" =~ ":error:" ]]; then
      error=$(echo -n ${result} | cut -d':' -f6)
      echo "${cipher}: NO ($error)"
    else
      if [[ "${result}" =~ "Cipher is ${cipher}" || "${result}" =~ "Cipher    :" ]]; then
        echo "${cipher}: YES"
      else
        echo "${cipher}: UNKNOWN (${result})"
      fi
    fi
    sleep ${PAUSE}
done
