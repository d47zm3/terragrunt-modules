#!/bin/bash

sleep 60
yum -y install nfs-utils
mkdir -p /export; chmod -R 777 /export
echo '/export 10.0.0.0/16(rw,no_root_squash,async)' > /etc/exports

if lsblk -f /dev/disk/by-id/google-nfs-data-disk | tail -n1 | grep -q 'ext4'
then
  echo 'Already Formatted...'
else
  mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-nfs-data-disk
fi

mount /dev/disk/by-id/google-nfs-data-disk /export/
cd /export
mkdir -p wordpress files fastighet bilder-arvikanyheter bilder-dalslanningen bilder-filipstadstidning bilder-fryksdalsbygden bilder-hjotidning bilder-karlskogatidning bilder-kt bilder-mariestadstidningen bilder-nkp bilder-nlt bilder-nwt bilder-provinstidningen bilder-saffletidningen bilder-sla bilder-varbilden bilder-vf
chown -R 82:82  wordpress bilder-arvikanyheter bilder-dalslanningen bilder-filipstadstidning bilder-fryksdalsbygden bilder-hjotidning bilder-karlskogatidning bilder-kt bilder-mariestadstidningen bilder-nkp bilder-nlt bilder-nwt bilder-provinstidningen bilder-saffletidningen bilder-sla bilder-varbilden bilder-vf
chown -R 1001:1001 files fastighet
chmod -R 770 .
systemctl enable nfs-server.service
systemctl start nfs-server.service
