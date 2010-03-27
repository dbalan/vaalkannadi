#!/bin/bash
# Author Dhananjay Navaneetham <mb.dhananjay@gmail.com>
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#'''Depends on rsync.'''

# The address of the mirrors to pull from.
RSYNCSOURCE1="rsync://ftp.iitm.ac.in/linux/ubuntu 
	      rsync://mirror.cse.iitk.ac.in/archlinux/
	      rsync://ftp.iitm.ac.in/linux/debian/"

BASEDIR="/mirror/releases/ubuntu/ /mirror/releases/debian /mirror/releases/archlinux"

# LOGPATH
LOGPATH=/mirror/misc/logs/

#Some functions
fatal (){
  echo $1
  SWIT="1"
}

warn (){
  date >> $LOGMIRROR/pulllog.txt
  echo $1 >> $LOGMIRROR/pulllog.txt
  echo "\n">> $LOGMIRROR/pulllog.txt
}


for dirpaths in $BASEDIR
  do
# Make directories in the system if not present.
    if [ ! -d ${dirpaths} ]; then
      warn "${dirpaths} does not exist yet, create it and try again"
    fi
  done

# Do the actual pull
while [ "$SWIT" != "0" ]
  do 
    warn "running"
    SWIT="0"
    rsync --verbose --recursive --times --links --hard-links --stats ${RSYNCSOURCE} ${BASEDIR} || fatal "Failed to rsync from ${RSYNCSOURCE}."
  done

warn "Completed"