#!  /bin/sh

IP2=111.53.93.1
IP1=192.168.0.1 //默认路由
BAIDU=www.baidu.com

SCNT=10
RCNT=7
IP=$IP1

switch_gw()
{
	DEST=""
	if [ "x$IP" == "x$IP1" ] ; then
		DEST=$IP2
	else
		DEST=$IP1
	fi

	route del default gw $IP
	route add default gw $DEST
	echo "cur default gw is" $DEST

	IP=$DEST

	return 0;
}

check_net()
{
	ip=$1;
	N=$2;
	sum=0;

	for((i=0;i<$N;i++)) ; do
		ping -W1 -c1 $ip > /dev/null 2>&1 && sum=$(($sum+1))
	done

	return $sum;
}


#IP=www.baidu.com

for((i=0;;i++)) ;  do

	check_net $BAIDU $SCNT
	rc=$?

	echo `date` "--check $IP, result=$rc / $SCNT"

	if [ $rc -ge $RCNT ] ; then
		echo $IP "OK"
		sleep 5
		continue
	fi

	echo `date` "start switch ip...."
	switch_gw && echo "switch OK."
done


