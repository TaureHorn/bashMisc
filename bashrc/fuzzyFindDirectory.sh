## function designed to go in a .bashrc file
#
# designed to fuzzy find directories and cd to a selected directory using the fzf package
#
#   USAGE
#   fd
#
#   RESULT
#   cd to directory using fzf fuzzy find cli search interface
#
function fd() {
    local dir=$(find * -type d 2>/dev/null | fzf)
    cd "$dir"
}
