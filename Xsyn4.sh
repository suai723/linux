#! /bin/bash

#同步多台服务器文件和同时执行多台服务器上的命令

# 参数1 是scp 本地文件路径 
# 参数2 是远程服务器路径
# 参数3 是远端ssh 需要执行的命令 其中如有空格 用双引号包住,如："sh test2.sh" 如果不跟参数3 则不执行命令 只传文件



IpGroup=(root@10.10.35.4 root@10.10.35.6 root@10.10.35.7)
for ip in ${IpGroup[@]}
do
	echo ************REMOTE:        $ip
	echo ************LOCAL PATH:    $1
	echo ************REMOTE PATH:   $2
	echo ************SSH COMMEND:   $3
	echo ""
    /usr/bin/expect <<-EOF
        spawn scp -r $1 $ip:$2
        expect {
                 "pass"
                          {
                                send "g2y6#t3%Q2N\n"
                          }
                 eof
                  {
                          sleep 5
                          send_user "eof\n"
                  }
          }
        send "exit\r"
        expect eof
EOF
	echo ""
	if [ "$3" ] ;then
			/usr/bin/expect <<-EOF
				spawn ssh $ip "source /etc/profile;$3"
				expect {
						 "pass"
								  {
										send "g2y6#t3%Q2N\n"
								  }
						 eof
						  {
								  sleep 5
								  send_user "eof\n"
						  }
				  }
				send "exit\r"
				expect eof
		EOF
	fi
	
	echo ""
	echo ---------------------finished-----------------
	echo ""
done

