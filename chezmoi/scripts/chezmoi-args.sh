#!/bin/sh

chezmoi_args() {
  # chezmoi builds the pager command before it exports CHEZMOI_*, the parent argv is the fallback
  if [ -z "$CHEZMOI_ARGS" ]; then
    CHEZMOI_ARGS=$(tr '\0' ' ' <"/proc/$PPID/cmdline")
    export CHEZMOI_ARGS
  fi

  # shellcheck disable=SC2086
  set -- $CHEZMOI_ARGS

  # drop 'chezmoi' and global arguments
  # reexport CHEZMOI_COMMAND since chezmoi doesn't provide CHEZMOI_* environment variables on pager
  while [ $# -gt 0 ]; do
    case $1 in
    apply | diff) export CHEZMOI_COMMAND="$1"; shift; break ;;
    *) shift ;;
    esac
  done

  while [ $# -gt 0 ]; do
    case $1 in
    -n | --dry-run) export CHEZMOI_DRY_RUN=1; shift ;;
    -x | --exclude) case ",$2," in *,scripts,*) export CHEZMOI_EXCLUDE_SCRIPTS=1 ;; esac; shift 2 ;;
    -x* | --exclude=*) case ",${1#-x},${1#*=}," in *,scripts,*) export CHEZMOI_EXCLUDE_SCRIPTS=1 ;; esac; shift ;;
    -*) shift ;;
    *) export CHEZMOI_TARGET="$1"; shift ;;
    esac
  done
}

chezmoi_args
