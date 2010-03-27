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

# The address of the mirrors to pull from
SYNC_SRC="$1/$2"
MRR_HOME="/mirror"

SYNC_MRR="$MRR_HOME/releases/$2/"
SYNC_LOG="$MRR_HOME/logs/$2/"
SYNC_LCK="$SYNC_LOG/sync-progress.lck"

# Log file.
LOG_FILE="pkgsync_$(date +%Y%m%d-%H).log"

# Function for logging
log-it(){
touch "$SYNC_LOGS/$LOG_FILE"
echo "=============================================" >> "$SYNC_LOGS/$LOG_FILE"
echo ">> $1 $(date --rfc-3339=second)"
}


#Make direectories in the system if not present.
    if [ ! -d ${SYNC_MRR} ]; then
      warn "${SYNC_MRR} does not exist yet, create it and try again"
    fi
  done

[ -f $SYNC_LCK ] && exit 1
touch "$SYNC_LCK"

# Create the log file and insert a timestamp
log-it "starting sync on"

rsync --verbose --recursive --times --links --hard-links --stats ${SYNC_SRC} ${SYC_MRR} >> "$SYNC_LOG/$LOG_FILE"|| log-it "Failed to rsync"

log-it "Successfully completed the Sync on"
rm -f "$SYNC_LCK"

