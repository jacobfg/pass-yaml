#!/usr/bin/env bash
# pass yaml - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2020 Jacob Fleming-Gale
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
# []

VERSION="0.0.1"
OATH=$(which oathtool)

cmd_yaml_usage() {
  cat <<-_EOF
Usage:

More information may be found in the pass-yaml(1) man page.
_EOF
  exit 0
}

cmd_yaml_version() {
  echo $VERSION
  exit 0
}

cmd_yaml_show() {
  [[ -z "$OATH" ]] && die "Failed to generate OTP code: oathtool is not installed."

  local opts json=""
  opts="$($GETOPT -o j -l json -n "$PROGRAM" -- "$@")"
  local err=$?
  eval set -- "$opts"
  while true; do case $1 in
    -j|--json) json="-j"; shift ;;
    --) shift; break ;;
  esac done

  [[ $err -ne 0 || $# -ne 1 ]] && die "Usage: $PROGRAM $COMMAND [--json,-j] pass-name"

  local path="${1%/}"
  local passfile="$PREFIX/$path.gpg"
  check_sneaky_paths "$path"
  [[ ! -f $passfile ]] && die "$path: passfile not found."

  contents="$($GPG -d "${GPG_OPTS[@]}" "$passfile")"
  # while read -r -a line; do
  #   if [[ "$line" == otpauth://* ]]; then
  #     otp_parse_uri "$line"
  #     break
  #   fi
  # done < <(echo "$contents")

  # local cmd
  # case "$otp_type" in
  #   totp)
  #     cmd="$OATH -b --totp"
  #     [[ -n "$otp_algorithm" ]] && cmd+=$(echo "=${otp_algorithm}"|tr "[:upper:]" "[:lower:]")
  #     [[ -n "$otp_period" ]] && cmd+=" --time-step-size=$otp_period"s
  #     [[ -n "$otp_digits" ]] && cmd+=" --digits=$otp_digits"
  #     cmd+=" $otp_secret"
  #     ;;

  #   hotp)
  #     local counter=$((otp_counter+1))
  #     cmd="$OATH -b --hotp --counter=$counter"
  #     [[ -n "$otp_digits" ]] && cmd+=" --digits=$otp_digits"
  #     cmd+=" $otp_secret"
  #     ;;

  #   *)
  #     die "$path: OTP secret not found."
  #     ;;
  # esac

  # local out; out=$($cmd) || die "$path: failed to generate OTP code."

  # if [[ "$otp_type" == "hotp" ]]; then
  #   # Increment HOTP counter in-place
  #   local line replaced uri=${otp_uri/&counter=$otp_counter/&counter=$counter}
  #   while IFS= read -r line; do
  #     [[ "$line" == otpauth://* ]] && line="$uri"
  #     [[ -n "$replaced" ]] && replaced+=$'\n'
  #     replaced+="$line"
  #   done < <(echo "$contents")

  #   otp_insert "$path" "$passfile" "$replaced" "Increment HOTP counter for $path."
  # fi

  # if [[ $clip -ne 0 ]]; then
  #   clip "$out" "OTP code for $path"
  # else
  #   echo "$out"
  # fi


  # OUTPUT=$(pass show "${@}")
  # # echo ok
  # if [ $? -gt 0 ] ; then
  #     # pass prints error message
  #     exit $?
  # fi

  # YOUTPUT=$(echo "password: $OUTPUT")


    

  # # crude - use yq ?
  # if egrep -c '^totp:' <<< "$YOUTPUT" >/dev/null 2>&1 ; then
  #   SECRET=$(yq r -CP - totp <<< "$YOUTPUT")
  #   TOKEN=$(oathtool --totp -b $SECRET)
  #   YOUTPUT=$(yq w -j - token "${TOKEN}" <<< "$YOUTPUT")
  #   #| jq 'del(.totp, .otpauth)' | yq r -CP $json -
  # fi
  # yq r -CP $json - <<< "$YOUTPUT"

  echo "password: ${contents}"
}

case "$1" in
  help|--help|-h)    shift; cmd_yaml_usage "$@" ;;
  version|--version) shift; cmd_yaml_version "$@" ;;
  show)              shift; cmd_yaml_show "$@" ;;
  *)                 cmd_yaml_show "$@" ;;
esac
exit 0
