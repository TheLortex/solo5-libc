#!/bin/sh


prog_NAME="$(basename $0)"

err()
{
    echo "${prog_NAME}: ERROR: $@" 1>&2
}

die()
{
    echo "${prog_NAME}: ERROR: $@" 1>&2
    exit 1
}

warn()
{
    echo "${prog_NAME}: WARNING: $@" 1>&2
}

usage()
{
    cat <<EOM 1>&2
usage: ${prog_NAME} [ OPTIONS ]
Configures the freestanding libc build system.
Options:
    --prefix=DIR:
        Installation prefix (default: /usr/local).
    --toolchain=TOOLCHAIN
        Solo5 toolchain flags to use.
EOM
    exit 1
}



MAKECONF_PREFIX=/usr/local
while [ $# -gt 0 ]; do
    OPT="$1"

    case "${OPT}" in
        --toolchain=*)
            CONFIG_TOOLCHAIN="${OPT##*=}"
            ;;
        --prefix=*)
            MAKECONF_PREFIX="${OPT##*=}"
            ;;
        --help)
            usage
            ;;
        *)
            err "Unknown option: '${OPT}'"
            usage
            ;;
    esac

    shift
done

[ -z "${CONFIG_TOOLCHAIN}" ] && die "The --toolchain option needs to be specified."

MAKECONF_CFLAGS="$(solo5-config --toolchain=$CONFIG_TOOLCHAIN --cflags)"

echo "Toolchain: $CONFIG_TOOLCHAIN"
echo "C flags: $MAKECONF_CFLAGS"
echo "Installation prefix: $MAKECONF_PREFIX"

cat <<EOM >Makeconf
# Generated by configure.sh
MAKECONF_PREFIX=${MAKECONF_PREFIX}
MAKECONF_CFLAGS=${MAKECONF_CFLAGS}
EOM
