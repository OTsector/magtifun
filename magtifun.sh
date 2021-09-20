#!/bin/bash
#
# type: Sender
# Name: MagtiFun SMS Sender
# App link: http://www.magtifun.ge/
#        _
#  07   [|] 0ffensive 7ester
#
# last edit: 20/09/2021 06:36 #beta version 0.7


if [ $# -lt 2 ]; then
	echo "use: "$0" [send to] [message]"; exit 1
fi

sendTo="$1"
msg="$2"

uname=""
passwd=""

cookie='/tmp/cookie' # Just for use once

function login {
	token=$(
		curl -sLgk 'http://www.magtifun.ge/' \
			-A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0.1) Gecko/20100101 Firefox/76.0.1' \
			-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
			-H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'DNT: 1' -H 'Connection: keep-alive' \
			-H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' \
			-c "$cookie" \
				|tr -d "\r\n\t\0"|sed 's/<input/\n&/g'|grep '<input.*name="csrf_token"' \
				|sed 's/value=/\n&/g'|grep 'value'|awk -F '"' '{print $2}'
	)
	[ ${#token} -eq 0 ] && return 1
	curl -sLgk 'http://www.magtifun.ge/index.php?page=11&lang=ge' -X POST \
		-A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0.1) Gecko/20100101 Firefox/76.0.1' \
		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
		-H 'Accept-Language: en-US,en;q=0.5' --compressed \
		-H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: http://www.magtifun.ge' \
		-H 'DNT: 1' -H 'Connection: keep-alive' \
		-H 'Referer: http://www.magtifun.ge/index.php?page=11&lang=ge' -b "$cookie" \
		-H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' \
		-d 'csrf_token='"$token"'&act=1&user='"$uname"'&password='"$passwd" \
			|grep -q 'მოგესალმებით'; return $?
}

function sendMsg {
	token=$(curl -sLgk 'http://www.magtifun.ge/index.php?page=2&lang=ge' \
		-A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0.1) Gecko/20100101 Firefox/76.0.1' \
		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
		-H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'DNT: 1' -H 'Connection: keep-alive' \
		-b "$cookie" \
		-H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' \
			|tr -d "\r\n\t\0"|sed 's/<input/\n&/g'|grep '<input.*name="csrf_token"' \
			|sed 's/value=/\n&/g'|grep 'value='|awk -F '"' '{print $2}'
	)
	curl -slgk 'http://www.magtifun.ge/scripts/sms_send.php' -X POST \
		-A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0.1) Gecko/20100101 Firefox/76.0.1' \
		-H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed \
		-H 'Content-Type: application/x-www-form-urlencoded' -H 'X-Requested-With: XMLHttpRequest' \
		-H 'Origin: http://www.magtifun.ge' -H 'DNT: 1' -H 'Connection: keep-alive' \
		-H 'Referer: http://www.magtifun.ge/index.php?page=2&lang=ge' -b "$cookie" \
		-H 'Pragma: no-cache' -H 'Cache-Control: no-cache' \
		-d 'csrf_token='"$token"'&message_unicode=0&messages_count=1&recipients='"$sendTo"'&total_recipients=0&recipient='"$sendTo"'&message_body='"$msg" \
			|grep -q "success"
	return $?
}

function deletePrev {
	lastPage=$(
		curl -sLgk 'http://www.magtifun.ge/index.php?page=10&lang=ge' \
			-A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0.1) Gecko/20100101 Firefox/76.0.1' \
			-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
			-H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'DNT: 1' \
			-H 'Connection: keep-alive' -b "$cookie" \
			-H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' \
				|tr -d "\r\n\t\0"|sed 's/<span class="page_number/\n&/g'|grep '<span class="page_number' \
				|tail -n 1|awk -F '"' '{print $4}'|sed 's/.*_//g'
	)
	[ ${#lastPage} -eq 0 ] && lastPage=1
	for((i=1;i<=$lastPage; i++)); do
		data=$(
			curl -sLgk 'http://www.magtifun.ge/index.php?page=10&lang=ge' -X POST \
				-A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0.1) Gecko/20100101 Firefox/76.0.1' \
				-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
				-H 'Accept-Language: en-US,en;q=0.5' --compressed \
				-H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: http://www.magtifun.ge' \
				-H 'DNT: 1' -H 'Connection: keep-alive' \
				-H 'Referer: http://www.magtifun.ge/index.php?page=10&lang=ge' \
				-b "$cookie" -H 'Upgrade-Insecure-Requests: 1' \
				-H 'Pragma: no-cache' -H 'Cache-Control: no-cache' --data-raw 'cur_page='$1'&fav_page=0' \
					|tr -d "\r\n\t\0"|sed 's/<div id="msg_/\n&/g'|grep '<div id="msg_' \
					|awk -F '"' '{print $2}'|sed 's/.*_//g'|awk '{print "&msg_id%5B%5D="$1}'|tr -d "\n"
		)
		curl -s 'http://www.magtifun.ge/scripts/delete_message.php' -X POST \
			-A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0.1) Gecko/20100101 Firefox/76.0.1' \
			-H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed \
			-H 'Content-Type: application/x-www-form-urlencoded' -H 'X-Requested-With: XMLHttpRequest' \
			-H 'Origin: http://www.magtifun.ge' -H 'DNT: 1' -H 'Connection: keep-alive' \
			-H 'Referer: http://www.magtifun.ge/index.php?page=10&lang=ge' \
			-b "$cookie" -H 'Pragma: no-cache' \
			-H 'Cache-Control: no-cache' --data-raw 'type=multype'"$data" &> /dev/null
	done
}

login || { echo "ERROR: can't logIn"; exit 1; }

sendMsg "Msg" || { echo "ERROR: can't send the message"; exit 1; }

deletePrev || { echo "ERROR: can't delete the messages"; }

