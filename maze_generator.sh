#!/bin/bash

maze_width=39
maze_height=21

function init_maze {
   for ((y=0; y<maze_height; y++)) ; do
      for ((x=1; x<$((maze_width-1)); x++)) ; do
         maze[$((y * maze_width + x))]=0
      done
      maze[$((y * maze_width + 0))]=1
      maze[$((y * maze_width + (maze_width - 1)))]=1
   done
   for ((x=0; x<maze_width; x++)) ; do
      maze[$x]=1
      maze[$(((maze_height - 1) * maze_width + x))]=1
   done
}

function print_maze {
   for ((y=0; y<maze_height; y++)) ; do
      for ((x=0; x<maze_width; x++ )) ; do
         if [[ ${maze[$((y * maze_width + x))]} -eq 0 ]] ; then
            echo -n "*"
         else
            echo -n " "
         fi
      done
      echo
   done
}

function carve_maze {
   local index=$1
   local dir=$(od -A n -t d -N 2 /dev/urandom |tr -d ' ')
   local i=0
   maze[$index]=1
   while [ $i -le 4 ] ; do
      local offset=0
      case $((dir % 4)) in
         0) offset=1 ;;
         1) offset=-1 ;;
         2) offset=$maze_width ;;
         3) offset=$((-$maze_width)) ;;
      esac
      local index2=$((index + offset))
      if [[ ${maze[$index2]} -eq 0 ]] ; then
         local nindex=$((index2 + offset))
         if [[ ${maze[$nindex]} -eq 0 ]] ; then
            maze[$index2]=1
            carve_maze $nindex
            i=0
            dir=$(od -A n -t d -N 2 /dev/urandom |tr -d ' ')
            index=$nindex
         fi
      fi
      i=$((i + 1))
      dir=$((dir + 1))
   done
}

init_maze
carve_maze $((2 * maze_width + 2))
maze[$((maze_width + 2))]=1
maze[$(((maze_height - 2) * maze_width + maze_width - 3))]=1
print_maze