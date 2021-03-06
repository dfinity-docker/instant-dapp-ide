echo "IMPORTANT: This port forwarding is for use with old versions of Mac OS X and old versions of docker."
echo "In the latest versions, the docker image creates ports on your host's localhost automatically."
echo "This script would block your docker image from doing that (only use with old versions)."

read -p "Do you want to do port forwarding? y/N: " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	socat TCP-LISTEN:8545,fork TCP:`docker-machine ip default`:8545 &
	socat TCP-LISTEN:8080,fork TCP:`docker-machine ip default`:8080 &
	socat TCP-LISTEN:8181,fork TCP:`docker-machine ip default`:8181 &
	socat TCP-LISTEN:2222,fork TCP:`docker-machine ip default`:2222 &
	socat TCP-LISTEN:3000,fork TCP:`docker-machine ip default`:3000 &
	socat TCP-LISTEN:3001,fork TCP:`docker-machine ip default`:3001 &

	MSG="\n\
	Forwarded localhost(2222, 8080, 8181, 8045) --> "`docker-machine ip default`"(22/SSH, 8080/Web, 8181/C9, 8045/RPC) \n\
	\n\
	Your pair programmer can connect... \n\
	-- $ ssh -p 2222 root@"`ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}'`" \n\
	-- $ tmux a -t pair    // you must already be waiting in a tmux session called pair\n\
	-- or.. launch c9 using c9.sh\n\
	\n\
	Debug your Dapp in Web browser... \n\
	-- open http://"`ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}'`":8080/ \n\
	-- in case you're wondering, RPC listens on port 8545 for calls from Dapp html/javascript \n\
	\n\
	Congrats, it is now easy to connect your instant-dapp-ide instance!!! \n"
	echo -e $MSG
fi
