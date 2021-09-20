# magtifun

## how to install:
	sudo wget -qU '' https://raw.githubusercontent.com/OTsector/magtifun/main/magtifun.sh -O /usr/bin/magtifun
	sudo chmod +x /usr/bin/magtifun
	read -p "Input username: " uname; read -sp "Input password: " passwd
	sed 's/uname=""/uname="'"$uname"'"/g;s/passwd=""/passwd="'"$passwd"'"/g' -i /usr/bin/magtifun; echo -e "\nDone!"
## One line command:
	sudo wget -qU '' https://raw.githubusercontent.com/OTsector/magtifun/main/magtifun.sh -O /usr/bin/magtifun && sudo chmod +x /usr/bin/magtifun; read -p "Input username: " uname; read -sp "Input password: " passwd; sed 's/uname=""/uname="'"$uname"'"/g;s/passwd=""/passwd="'"$passwd"'"/g' -i /usr/bin/magtifun; echo -e "\nDone!"
