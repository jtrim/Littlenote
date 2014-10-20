function __ensure_littlenotes_file() {
  LITTLENOTE_FILENAME=littlenotes.txt

  if [[ -e $HOME/Dropbox ]]; then
    export LITTLENOTE_NOTE_PATH=$HOME/Dropbox/$LITTLENOTE_FILENAME
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
}

function __pop_last_note() {
  LITTLENOTES=$(cat $LITTLENOTE_NOTE_PATH)
  echo $LITTLENOTES | sed '$ d' > $LITTLENOTE_NOTE_PATH
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

  # n --amend
  elif [[ "${1}" =~ --amend ]]; then
    __amend_last_note

  # n --pop
  elif [[ "${1}" =~ --pop ]]; then
    __pop_last_note

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
