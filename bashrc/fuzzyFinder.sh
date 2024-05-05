#! /usr/bin/env/ bash

# fzf (fuzzy finder) functions
ffd() {
    dir="$1"
    home="/home/$(whoami)"
    if [ "$1" == "/" ]; then
        # search root. -xdev excludes other filesystems - in this case an nfs share
        dir=$(find ./ -type d -xdev -not -path "./media/*" -not -path "./home/*" -not -path "*/.*" 2>/dev/null | fzf)
    elif [ "$1" == "$home" ];then
        # search home not excluding hidden directories
        dir=$(find ./ -type d 2>/dev/null | fzf)
    else
        # search directory excluding hidden subdirectories
        dir=$(find ./ -type d -not -path "*/.*" 2>/dev/null | fzf)
    fi
    cd "$dir" || return
}

fff() {
    local path
    local file
    local ext

    path="$1"
    home="/home/$(whoami)"
    if [ "$1" == "/" ]; then
        # search root. -xdev excludes other filesystems - in this case an nfs share
        path=$(find ./ -type f -xdev -not -path "./media/*" -not -path "./home/*" -not -path "*/.*" 2>/dev/null | fzf)
    elif [ "$1" == "$home" ]; then
        # search home not excluding hidden directories
        path=$(find ./ -type f 2>/dev/null | fzf)
    else
        # search directory excluding hidden subdirectories
        path=$(find ./ -type f -not -path "*/.*" 2>/dev/null | fzf)
    fi

    file=$(echo "$path" | sed 's/.*\///') # get filename
    ext=$(echo "$path" | sed 's/.*\.//') # get file extension
    ext=$(echo $ext | awk '{print tolower($0)}')

    case $ext in
        jpg | png | gif | webp) # images
            echo "Launching image file '"$file"' with chafa"
            chafa "$path" || return;;
        txt) # text
            echo "Reading text file '"$file"' using bat"
            bat "$path" || return;;
        docx | doc | xlsx )
            echo "Launching file '"$file"' using libreoffice"
            libreoffice "$path" || return;;
        epub | mobi)
            echo "Reading book '"$file" using epr-reader"
            epr "$path" || return;;
        md) # markdown
            echo "Rendering markdown file '"$file"' with glow"
            glow -l "$path" || return;;
        pdf) # pdf
            echo "Launching pdf file '"$file"' using okular"
            okular "$path" || return;;
        mp3 | wav | ogg | flac) # audio
            echo "Playing audio file '"$file"' using mpv"
            mpv --vo=tct "$path" || return;;
        mp4 | mkv | webm | flv | avi) # video
            echo "Playing video file '"$file"' using mpv"
            mpv "$path" || return;;
        session) # nvim session
            echo "Launching neovim session '"$file"' using nvim"
            nvim -S "$path" || return;;
        js | jsx | json | cjs | css | scss | html | sh | go | ts | rs | lua | py | conf ) # code
            echo "Launching nvim to edit file '"$file"'"
            nvim "$path" || return;;
        *) # ooops
            return
    esac
}

ff(){
    local dir
    dir="$(pwd)"

    # Uncomment out var below and fill with a list of folders
    # local dir_loc=("/" "~/" "/mnt")
    # local dir_name=("ROOT" "HOME" "MNT")
    local avail_loc=()
    local avail_name=()

    for (( i=0; i<${#dir_loc[@]}; i++));
    do
        if [ -d "${dir_loc[$i]}" ]; then
            avail_loc+=("${dir_loc[$i]}")
            avail_name+=("${dir_name[$i]}")
        fi
    done

    local destination
    destination=$(gum choose "${avail_name[@]}")

    for (( x=0; x<${#dir_name[@]}; x++));
    do
        if [ "$destination" == "${dir_name[$x]}" ]; then
            destination="${dir_loc[$x]}"
        fi
    done

    cd "$destination" || exit

    ###################################
    local target
    target="$(gum choose "DIRECTORY" "FILE")"
    if [[ "$target" == "DIRECTORY" ]]; then 
        ffd "$destination" || exit
    elif [[ "$target" == "FILE" ]]; then
        fff "$destination";cd "$dir" || exit
    fi
}

