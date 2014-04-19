#!/bin/sh
php=`which php`
cron="/var/www/admin.emag/app/console cron"
$php $cron $@
