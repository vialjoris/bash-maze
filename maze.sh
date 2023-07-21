#!/bin/bash
cd $(dirname $0)

pos="X"
empty=" "
wall="*"
up=0
down=0
left=0
right=0

function print_maze(){
    clear
    for ((i=0; i<${#maze[@]}; i++)); do
        echo "${maze[$i]}"
    done
}

maze=()
while IFS= read -r line; do
    maze+=("$line")
done < <(bash ./maze_generator.sh)

pos_x=1
pos_y=1

while true; do
    maze[$pos_y]="${maze[$pos_y]:0:$pos_x}$empty${maze[$pos_y]:$((pos_x + 1))}"

    if ((up)); then
        newpos_y=$((pos_y - 1))
        if [[ "${maze[$newpos_y]:$pos_x:1}" != "${wall}" ]]; then
            pos_y=$newpos_y
        fi
    elif ((down)); then
        newpos_y=$((pos_y + 1))
        if [[ "${maze[$newpos_y]:$pos_x:1}" != "${wall}" ]]; then
            pos_y=$newpos_y
        fi
    elif ((right)); then
        newpos_x=$((pos_x + 1))
        if [[ "${maze[$pos_y]:$newpos_x:1}" != "${wall}" ]]; then
            pos_x=$newpos_x
        fi
    elif ((left)); then
        newpos_x=$((pos_x - 1))
        if [[ "${maze[$pos_y]:$newpos_x:1}" != "${wall}" ]]; then
            pos_x=$newpos_x
        fi
    fi

    maze[$pos_y]="${maze[$pos_y]:0:$pos_x}$pos${maze[$pos_y]:$((pos_x + 1))}"

    if [ $pos_y == "20" ];then
        
        echo "you win"
        exit 
    fi

    print_maze


    read -rsn3 input
    case "$input" in
        $'\e[A')
            up=1
            down=0
            left=0
            right=0
        ;;
        $'\e[B')
            up=0
            down=1
            left=0
            right=0
        ;;
         $'\e[C')
            up=0
            down=0
            left=0
            right=1
        ;;
         $'\e[D')
            up=0
            down=0
            left=1
            right=0
        ;;
    esac
done