This is Littlenote.
===================

It helps you keep track of notes you need to record quickly and forget about until later.
#########################################################################################

``` bash
source littlenote.sh

# Oh, just thought of something
n "Something I just thought of"


# Wait, what was that thing I thought of earlier?
n
# Prints the last ten notes like this:
# 12/03/2011 03:04:17 PM -  Something I just thought of


# I recorded something awhile ago...what was that?
n -n 50
# Prints the last fifty notes
```

About
=====

If you're using Dropbox (and Dropbox is installed to the default location),
the file path defaults to $HOME/Dropbox/littlenotes.txt. Otherwise, it's
stored in $HOME/littlenotes.txt.
