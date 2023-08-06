## function designed to go in a .bashrc file
#
# designed to fuzzy find images files using the fzf package and open them in qview
#
#   USAGE
#   fimg
#
#   RESULT
#   fuzzy find .jpg, .png, and .gif files with the fzf cli interface and open selected file in qview
#
function fimg() {
    local img=$(find * -name "*.jpg" -o -name "*.png" -o -name "*.gif" -type f 2>/dev/null | fzf)
    qview "$img"
}

