#!/bin/bash -
#===============================================================================
#
#          FILE: start_libcirt_service.sh
#
#         USAGE: ./start_libcirt_service.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: James Lee (JamesL), princeofdream@outlook.com
#  ORGANIZATION: BookCL
#       CREATED: 2020年11月11日 07时08分13秒
#      REVISION:  ---
#===============================================================================

# set -o nounset                                  # Treat unset variables as an error

service_list="
libvirtd.service
libvirt-guests.service
virtinterfaced.service
virtlockd.service
virtlogd.service
virtlxcd.service
virtnetworkd.service
virtnodedevd.service
virtnwfilterd.service
virtproxyd.service
virtqemud.service
virtsecretd.service
virtstoraged.service
virtvboxd.service
"

echo -e "${service_list}" | while read item;
do
	if [[ ${item}"" != *".service" ]]; then
		continue
	fi
	echo "---> ${item}"
	sudo systemctl restart ${item}
done


