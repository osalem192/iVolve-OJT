#########################################################
#       Author:                 Omar Ahmed Salem        #
#       Date of Creation:       25Jun2025               #
#       Last Edited :           25Jun2025               #
#                                                       #
#   This is a basic script that takes a backup from     #
#   mysql db                                            #
#########################################################

#!/bin/bash

BACKUP_DIR="$HOME/mysql_backups"
DATE=$(date +\%F_\%H-\%M)
DB_NAME="testdb"
USER="backupuser"
#db_pass is a global variable defined outside of the script

if [ -d $BACKUP_DIR ]
then
:
else
        mkdir -p "$BACKUP_DIR"
fi

mysqldump --no-tablespaces -u backupuser -p"$db_pass"  testdb > "$BACKUP_DIR/MySQL_backup_$DATE.sql"

#checking whether the command completed successfully
if [ $? -eq 0 ]
then
        echo "Backup completed successfully"
else
        echo "Bakcup failed"
fi
