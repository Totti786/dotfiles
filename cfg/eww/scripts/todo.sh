#!/bin/bash

# Define the path to the to-do list file
TODO_FILE="$HOME/.cache/eww/todo.txt"

# Display the usage message if no arguments are provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 add|remove|list|mark|show|check [item]"
    exit 1
fi

## Define functions for each command
#add_todo() {
    #echo "$@" >> "$TODO_FILE"
    #echo "Added '$@' to to-do list."
#}

add_todo() {
    echo "$(zenity --entry --text "Enter Task:")" >> "$TODO_FILE"
}

#remove_todo() {
    #if [[ $# -eq 0 ]]; then
        #echo "Usage: $0 remove [item number]"
        #exit 1
    #fi
    #sed -i "${1}d" "$TODO_FILE"
    #echo "Removed item $1 from to-do list."
#}

remove_todo() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 remove [item]"
        exit 1
    fi

    # Search for the string in the to-do list file
    if grep -q "$@" "$TODO_FILE"; then
        # Delete the line that contains the string
        sed -i "/$@/d" "$TODO_FILE"
        echo "Removed '$@' from to-do list."
    else
        echo "'$@' not found in to-do list."
    fi
}

list_todos() {
    cat -n "$TODO_FILE"
}

list_raw_todos() {
    cat "$TODO_FILE"
}

mark_number() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0  [item number]"
        exit 1
    fi
    if [[ $(sed -n "${1}s/^\(.\).*$/\1/p" "$TODO_FILE") == "#" ]]; then
        # Task is already marked as done, so unmark it
        sed -i "${1}s/^#//" "$TODO_FILE"
        echo "Unmarked item $1 as done."
    else
        # Task is not marked as done, so mark it
        sed -i "${1}s/^/#/" "$TODO_FILE"
        echo "Marked item $1 as done."
    fi
}

mark_item() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 mark [item]"
        exit 1
    fi

    # check if item is already marked as done
    if grep -Fxq "#$1" "$TODO_FILE"; then
        # remove the '#' to mark the item as undone
        sed -i "s/#$1/$1/" "$TODO_FILE"
        echo "Marked '$1' as undone."
    elif grep -Fxq "$1" "$TODO_FILE"; then
        # add the '#' to mark the item as done
        sed -i "s/^$1/#&/" "$TODO_FILE"
        echo "Marked '$1' as done."
    else
        echo "Item '$1' not found in to-do list."
        exit 1
    fi
}

show_todo() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 show [item number]"
        exit 1
    fi
    sed -n "s/^#*//;${1}p" "$TODO_FILE"
}

check_todo() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 check [item number]"
        exit 1
    fi
    if [[ $(sed -n "${1}s/^\(.\).*$/\1/p" "$TODO_FILE") == "#" ]]; then 
		echo "${1} is done"
    else	
		echo "${1} is not done"
    fi
}

eww_todo() {
	list=$(
		while read line; do if [[ $(echo $line | sed -n "${1}s/^\(.\).*$/\1/p") == "#" ]]; then 
		   echo "(box :space-evenly false :spacing 5 :orientation 'h' :class 'line' \
				(button :class 'button' :onclick './scripts/todo.sh mark \"${line:1}\"' '') \
				(label :wrap true :markup '<span strikethrough=\"true\">${line:1}</span>') \
				(button :class 'button' :halign 'end' :onclick './scripts/todo.sh remove \"$line\"' ''))"
		else
		   echo "(box :space-evenly false :spacing 5 :orientation 'h' :class 'line' \
				(button :class 'button' :onclick './scripts/todo.sh mark \"$line\"' '') \
				(label :wrap true :text \"$line\") \
				(button :class 'button' :halign 'end' :onclick './scripts/todo.sh remove \"$line\"' ''))"
		fi
		done < "$TODO_FILE" | tr '\n' ' '
	)
	echo "(scroll :height 150 :width 300 :vscroll true \
	(box :orientation 'v' :spacing 10 :class 'todo' :space-evenly 'false' $list \
	(box :space-evenly 'true' :spacing 5 :orientation 'h' :class 'line' \
	(button :onclick './scripts/todo.sh add' ''))))"
}

literal_listen() {
    eww_todo
     
	while sleep 0.5; do
		inotifywait -qe modify $TODO_FILE
		eww_todo
	done
}

# Call the appropriate function based on the command line argument
case $1 in
    add)
        shift
        add_todo "$@"
        ;;
    remove)
        shift
        remove_todo "$@"
        ;;
    list)
		shift
        list_todos
        ;;
    mark)
        shift
        mark_item "$@"
        ;;
    show)
        shift
        show_todo "$@"
        ;;
    check)
        shift
        check_todo "$@"
        ;;
    literal)
        shift
        literal_listen
        ;;
    *)
        echo "Usage: $0 add|remove|list|mark|show|check [item]"
        exit 1
        ;;
esac
