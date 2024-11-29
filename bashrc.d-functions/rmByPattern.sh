## function designed to go in a .bashrc file
#
# designed to recursively delete all files matching a specified name pattern
#
#   USAGE
#   rmPattern
#
#   RESULT
#   find ./ -name "$SEARCH_PATTERN" -exec rm -r {} \;

rmPattern() {
    echo -e '\033[1mWarning! This recursively deletes all files matching a specified pattern!\033[0m'
    echo 'Input a pattern below. Files matching this pattern will be deleted'
    read -p 'Pattern: ' SEARCH_PATTERN
    $(find ./ -name "$SEARCH_PATTERN" -exec rm -r {} \;)
}
