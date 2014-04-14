#!/bin/sh
php=`which php`
cron="/var/www/www.emag/app/console route:match"
$php $cron $@
