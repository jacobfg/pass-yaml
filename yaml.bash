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

cmd_yaml_usage() {
  cat <<-_EOF
Usage:

    $PROGRAM otp [show] [--otp,-o] pass-name
        Generate an OTP code and optionally put it on the clipboard.
        If put on the clipboard, it will be cleared in $CLIP_TIME seconds.

More information may be found in the pass-yaml(1) man page.
_EOF
  exit 0
}

cmd_yaml_version() {
  echo $VERSION
  exit 0
}

cmd_otp_code() {
#   pass show "${@}" | sed '1s/^/password: /' | yq r -CP -
  ( echo -n "password: " ; pass show "${@}" ) | yq r -CP -
}

case "$1" in
  help|--help|-h)    shift; cmd_yaml_usage "$@" ;;
  version|--version) shift; cmd_yaml_version "$@" ;;
  show)              shift; cmd_yaml_code "$@" ;;
  *)                 cmd_yaml_code "$@" ;;
esac
exit 0
