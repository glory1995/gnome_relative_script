#!/usr/bin/bash

# A bash run file for updating gnome system proxy ignore-hosts

# debug
# echo "new host: $1"
if [[ "$1" != 'show' ]] && [[ "$1" != 'add' ]] && [[ "$1" != 'delete' ]]
then
  echo "Err: One of 'show|add {host}|delete {host}' was expected to occur as parameters!"
  exit
fi

if [[ "$1" != 'show' ]] && [[ "$2" == '' ]]
then
  echo "Err: A host address was expected to occur as the 2nd parameter!"
  exit
fi

hosts1=$(gsettings get org.gnome.system.proxy ignore-hosts)
# debug

if [[ "$1" == "show" ]]
then
    echo "Gnome system proxy ignore-hosts:"
    echo "$hosts1"
    exit
fi

IFS='[' read -r -a hosts2 <<< "$hosts1"
IFS=']' read -r -a hosts3 <<< "${hosts2[1]}"
IFS=',' read -r -a array <<< "${hosts3[0]}"

if [[ "$1" == "delete" ]]
then
    EXISTS="true"
    exists="false"
    for i in ${!array[@]}
    do
      # debug
      # echo "${array[i]}"
      if [[ "${array[i]}" == " '$2'" ]]
      then
        exists="$EXISTS"
        echo "Deleting existing host: '$2'..."
        unset array[i]
      fi
    done

    if [[ "$exists" != "$EXISTS" ]]
    then
      echo "The host '$2' was not presented in ignore lists thus updating was aborted."
      exit
    fi

    var=$( IFS=$','; echo "${array[*]}" )
    # debug
    # echo "[${var}]"

    gsettings set org.gnome.system.proxy ignore-hosts "[${var}]"

    echo "'$2' has been deleted successfully."
    exit
fi

# if [[ "$1" != 'show' ]]

for host_addr in ${array[@]}
do
  # remove leading spaces 
  host_addr1=`echo ${host_addr}|sed 's/^ *//g'`
  # debug
  # echo "${host_addr1}"
  if [[ "${host_addr1}" == "'$2'" ]]
  then
    echo "The host '$2' was already presented in ignore lists thus updating was aborted."
    exit
  fi
done

echo "Adding new host: '$2'..."

array+=(" '$2'")
var=$( IFS=$','; echo "${array[*]}" )

# debug
# echo "[${var}]"

gsettings set org.gnome.system.proxy ignore-hosts "[${var}]"

echo "'$2' has been added successfully."