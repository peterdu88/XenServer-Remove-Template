#!/bin/bash

function tempalte_uuid_processor(){
    uuid=$1
	
#   error=`xe template-param-set other-config:default_template=false uuid=$uuid`
	if [[ $(xe template-param-set other-config:default_template=false uuid=$uuid | wc -c) -ne 0 ]] ; then
		echo "disable template failed"
		return
	fi
#		error=`xe template-param-set is-a-template=false uuid=$uuid`
	if [[ $(xe template-param-set is-a-template=false uuid=$uuid |wc -c) -ne 0 ]] ; then
		echo "disable template failed"
		return
	fi
		
#   error=`xe vm-destroy uuid=$uuid`
	if [[ $(xe vm-destroy uuid=$uuid |wc -c) -ne 0 ]] ; then
		echo "destroy template failed"
		return
	fi

    echo "finished"
}

function usage(){
	desc << EndofMessage
*************************************************************************************************
        Author: Peter Du <peter.du@dare-auto.us>
        Date: April 3, 2019
        Description: This script is trying to remove unused tempalte.

        Format:
           ./removeTemplate.sh Template name
            - Template name: you had better get it from XenCenter or command xe template-list
            - Notice: make sure the name was quoted by double quote ""

        For example:
            ./removeTemplate.sh "Debian Wheezy 7.0 (32-bit)"
**************************************************************************************************

EndofMessage
}

#check name-label varaible input
if [ $# -ne 1 ] ; then
	echo "Bad number of args "
	usage
#	return
else
	#check name-label varaible input
	labelname=$1

	uuid=`xe template-list name-label="$labelname"  is-a-template=true --minimal`
	if [ -z "$uuid" ] ; then
		echo "did not find target: $labelname"
	else
		echo "Find Target UUID is:$labelname\n$uuid"
		while true; do
			read -p "Do you wish to delete this template?(y/n)" yn
			case $yn in
				[Yy]* ) 
					echo "trying to deleting $labelname ( $uuid )......."
					tempalte_uuid_processor $uuid
					break
					;;
				[Nn]* ) exit;;
				* ) echo "Please answer yes or no.";;
			esac
		done
	fi
fi
