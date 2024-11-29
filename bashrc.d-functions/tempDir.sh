## function designed to go in a .bashrc file
#
# designed to create temporary directory bookmarks both as session variables and cd aliases
# only works as a function within .bashrc as the variables expire as soon as the script ends, if run as a standalone .sh script
#
#   USAGE
#   tempDir varName
#
#   RESULT
#   session variable of varName and alias varName="cd varName"
#
function tempDir() {
    #called with variable name as first argument
    local parsedDir=$(printf "%q\n" "$(pwd)")
    local varName=$1

    if [[ -z "$varName" ]]; then
        echo -e '\033[1mName cannot be blank\033[0m'
    elif [[ -v $varName ]]; then
        echo -e '\033[1mVariable "'$varName'" already exists\033[0m'
    else
        # success
        eval $varName="$parsedDir"
        alias $varName="cd $parsedDir"
        echo -e  '\033[1mDirectory Path:' $parsedDir'\033[0m'
        echo -e 'You can cd to this directory with the alias: \033[1m'$varName '\033[0m'
        echo -e 'You can use this directory as a command argument with the variable: \033[1m"$'$varName'"\033[0m'
    fi
}
