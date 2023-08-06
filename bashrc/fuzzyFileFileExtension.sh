## function designed to go in a .bashrc file
#
# designed to fuzzy find files by file extension using the fzf package
#
#   USAGE
#   ffext
#
#   RESULT
#   input box for file extension to search, copies path of a selected file to terminal clipboard using xclip
#
function ffext(){
    echo 'Fuzzy find files by file extension'
    read -p 'What file extension do you want to search for?: ' search
    local ext="."
    ext+=$search

    local find=$(find * -name "*"$ext"" -type f 2>/dev/null | fzf)
    echo -e '\033[1m'$find'\033[0m'
    echo "$find" | xclip -sel clip
}
