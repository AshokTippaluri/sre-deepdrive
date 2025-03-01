 docker rm $(docker ps -a -q -f status=exited)
 
du -sh * | sort -rh | head

ps aux --sort=-%cpu | head
