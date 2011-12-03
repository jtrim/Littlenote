function __print_littlenote_usage() {
  echo ""
  echo "Littlenote: Record a datetime-stamped message to a notes file in /Users/<your-username>/Documents/nnotes.txt"
  echo ""
  echo "Usage: n [-h|--help] [-n <lines-of-scrollback>] <message-to-record>"
  echo ""
  echo "Examples:"
  echo ""
  echo "  Record a new note:"
  echo "    n \"My new note\""
  echo ""
  echo "  List the last ten notes:"
  echo "    n"
  echo ""
  echo "  List the last 40 notes:"
  echo "    n -n 40"
  echo ""
}

function __ensure_littlenotes_file() {
  LITTLENOTE_FILENAME=littlenotes.txt

  if [[ -e $HOME/Dropbox ]]; then
    export LITTLENOTE_NOTE_PATH=$HOME/Dropbox/$LITTLENOTE_FILENAME
    if [[ ! -e $LITTLENOTE_NOTE_PATH ]]; then
      touch $LITTLENOTE_NOTE_PATH
    fi
  else
    export LITTLENOTE_NOTE_PATH=$HOME/$LITTLENOTE_FILENAME
    if [[ ! -e $LITTLENOTE_NOTE_PATH ]]; then
      touch $LITTLENOTE_NOTE_PATH
    fi
  fi
}

function n() {
  __ensure_littlenotes_file

  DATE=`date '+%m/%d/%Y %I:%M:%S %p - '`

  # n (call with no args)
  if [ "${1}" = "" ]; then
    tail -n 10 $LITTLENOTE_NOTE_PATH

  # n --help or n -h
  elif [[ "${1}" =~ ^-h ]] || [[ "${1}" =~ ^--help ]]; then
    __print_littlenote_usage

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
