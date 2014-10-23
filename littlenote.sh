function __ensure_littlenotes_file() {
  LITTLENOTE_FILENAME=littlenotes.txt

  if [[ -e $HOME/Dropbox ]]; then
    export LITTLENOTE_NOTE_PATH=$HOME/Dropbox/$LITTLENOTE_FILENAME
  elif [[ -e $HOME/Dropbox\ \(Personal\) ]]; then
    export LITTLENOTE_NOTE_PATH=$HOME/Dropbox\ \(Personal\)/$LITTLENOTE_FILENAME
  else
    export LITTLENOTE_NOTE_PATH=$HOME/$LITTLENOTE_FILENAME
  fi

  if [[ ! -e $LITTLENOTE_NOTE_PATH ]]; then
    touch $LITTLENOTE_NOTE_PATH
  fi
}

function __print_littlenote_usage() {
  __ensure_littlenotes_file

  cat <<-README

Littlenote: Record a datetime-stamped message to a notes file

  Current file path: ${LITTLENOTE_NOTE_PATH}

Usage: n [show] [-h|--help] [-n <lines-of-scrollback>] <message-to-record>

Examples:

  Record a new note:
    n "My new note"

  List the last ten notes:
    n

  List the last 40 notes:
    n -n 40

  Show the location of the notes file:
    n show

README
}

function __amend_last_note() {
  TMP_FILEPATH="/tmp/littlenote-amend-$(date +%s).txt"
  echo "Amending $(tail -n 1 $LITTLENOTE_NOTE_PATH)"

  tail -q -n1 $LITTLENOTE_NOTE_PATH > $TMP_FILEPATH

  $EDITOR $TMP_FILEPATH

  __pop_last_note

  cat $TMP_FILEPATH >> $LITTLENOTE_NOTE_PATH

  rm $TMP_FILEPATH

  n
}

function __pop_last_note() {
  LITTLENOTES=$(cat $LITTLENOTE_NOTE_PATH)
  echo $LITTLENOTES | sed '$ d' > $LITTLENOTE_NOTE_PATH
}

function __edit_notes() {
  $EDITOR $LITTLENOTE_NOTE_PATH
}

function __insert_divider_into_notes() {
  n "##############################################"
}

function __show_all_notes() {
  cat $LITTLENOTE_NOTE_PATH
}

function __littlenotes_for_date() {
  n --all | grep "^$1"
}

function n() {
  __ensure_littlenotes_file

  DATE=`date '+%m/%d/%Y %I:%M:%S %p -'`

  # n (call with no args)
  if [ "${1}" = "" ]; then
    tail -n 10 $LITTLENOTE_NOTE_PATH

  # n --help or n -h
  elif [[ "${1}" =~ ^-h ]] || [[ "${1}" =~ ^--help ]]; then
    __print_littlenote_usage

  # n --all
  elif [[ "${1}" =~ --all ]]; then
    __show_all_notes

  # n --amend
  elif [[ "${1}" =~ --amend ]]; then
    __amend_last_note

  # n --pop
  elif [[ "${1}" =~ --pop ]]; then
    __pop_last_note

  # n --edit
  elif [[ "${1}" =~ --edit ]]; then
    __edit_notes

  # n -d 10/21
  elif [[ "${1}" =~ -d ]]; then
   __littlenotes_for_date $2

  # n --div
  elif [[ "${1}" =~ --div ]]; then
    __insert_divider_into_notes

  # n show
  elif [[ "${1}" == show ]]; then
    echo $LITTLENOTE_NOTE_PATH

  # n -n 30 (30 gets passed on to the -n option of tail)
  elif [[ "${1}" =~ ^-n ]] && [ "${1}" != "" ]; then
    tail -n $2 $LITTLENOTE_NOTE_PATH

  # n --some-option-that-doesnt-exist
  elif [[ "${1}" =~ ^- ]]; then
    echo "n: unknown option specified: $1"

  # n "some note to record"
  else
    if [ ! -f $LITTLENOTE_NOTE_PATH ]
    then
      touch $LITTLENOTE_NOTE_PATH
    fi

    echo $DATE $1 >> $LITTLENOTE_NOTE_PATH
  fi

}
