export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

function tree {
find $&;{1:-.} -print | sed -e ’s;[^/]*/;|____;g;s;____|; |;g’
}
