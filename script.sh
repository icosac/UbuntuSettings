#!/bin/bash

#COLORS
RED='tput setaf 1'
GREEN='tput setaf 2'
CYANE='tput setaf 6'
NC='tput sgr0'
BOOL=true

myecho () {
	echo $1
	echo $($NC)
}

check (){
	if [ -f /usr/bin/$1 ]; then
		BOOL=true
	else
		if [ -f /bin/$1 ]; then
			BOOL=true
		else
			if [ -f /sbin/$1 ]; then
				BOOL=true
			else
				if [ -f /usr/sbin/$1 ]; then
					BOOL=true
				else
					BOOL=false
				fi
			fi
		fi
	fi
}

DIR=$HOME/Scaricati
CONDADIR=$HOME/anaconda3

if [ "$(id -u)" != "0" ]; then
	myecho "$($RED)You need to be root to execute the script"
	exit 1
else
	###########################
	## UPDATE ##
	###########################

	myecho "$($CYANE) Upgrading"
	sudo apt-get update
	echo 'y\n' | sudo apt-get upgrade

	###########################
	## ESSENTIAL ##
	###########################

	myecho "$($CYANE) Building essential"
	#Python
	#2.7
	check "python2.7"
	if [ $BOOL = true ]; then
		myecho "$($GREEN)Python 2.7 already exists"
	else
		cd /usr/src
		sudo wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
		sudo tar -xzf Python-2.7.13.tgz
		cd Python-2.7.13
		sudo ./configure
		sudo make altinstall
	fi
	#3.6
	check "python3.6"
	if [ $BOOL = false ]; then
		myecho "$($RED)python3.6 not found. Looking for 3.5"
		check "python3.5"
	fi
	if [ $BOOL = true ]; then
		myecho "$($GREEN)Python 3.6 (or 3.5) already exists"
	else
		sudo add-apt-repository ppa:jonathonf/python-3.6
		sudo apt-get update
		sudo apt-get install python3.6
	fi

	#HTOP
	sudo apt-get install htop
	#GCC
	check "gcc"
	if [ $BOOL = true ]; then
		sudo apt-get install gcc
	fi
	#G++
	chekck "g++"
	if [ $BOOL = true ]; then
        sudo apt-get install g++
	fi
	#pip
	wget https://bootstrap.pypa.io/get-pip.py -O $DIR/pip.py
	sudo python $DIR/pip.py
	rm $DIR/pip.py
	#easy_install
	sudo apt-get install python-setuptools
	#pygments
	sudo pip install pygments


	###########################
	## ATOM ##
	###########################
	myecho "$($CYANE) Installing atom"
	check "atom"
	if [ $BOOL = true ]; then
		myecho "$($GREEN)Atom already installed."
	else
 		wget https://atom-installer.github.com/v1.21.0/atom-amd64.deb?s=1506980949&ext=.deb -O atom.deb
		dpkg --install $DIR/atom.deb
	fi

	###########################
	## ANACONDA ##
	###########################
	myecho "$($CYANE) Installing anaconda"
	if [ -d $CONDADIR ]; then
		myecho "$($GREEN)Anaconda is already installed"
	else
		cd $DIR && wget -nc https://repo.continuum.io/archive/Anaconda3-5.0.0.1-Linux-x86_64.sh -O Anaconda.sh
		if [ -f $DIR/Anaconda.sh ]; then
			chmod +x $DIR/Anaconda.sh && $DIR/Anaconda.sh
		else
			myecho "$($RED)Couldn't find Anaconda"
		fi
	fi

	##########################
	## LATEX ##
	##########################
	myecho "$($CYANE) Installing tex"
	check texlive-full
	if [ "$(dpkg -s texlive-full)" > /dev/null ]; then
		myecho "$($GREEN)texlive-full is already installed"
	else
		sudo apt-get install texlive-full texwork texstudio
	fi

	##########################
	## SPOTIFY ##
	##########################
	myecho "$($CYANE) Installing Spotify"
	check "spotify"
	if [ $BOOL = true ]; then
		myecho "$($GREEN)Spotify is already installed"
	else
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410
		echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
		sudo apt-get update
		sudo apt-get install spotify-client
	fi

	#########################
	## BRIGHTNESS CONTROL CENTER ##
	#########################
	myecho "$($CYANE) Installing brightness-controller"
	check "brightness-controller"
	if [ $BOOL = true ]; then
		myecho "$($GREEN)brightness-controller is already installed"
	else
		echo '\n' sudo add-apt-repository ppa:apandada1/brightness-controller < yes
		sudo apt-get update
		sudo apt-get install brightness-controller
	fi

	#########################
	## CPU TEMP
	#########################
	myecho "$($CYANE) Installing Psensor"
	check "psensor"
	if [ $BOOL = true ]; then
		myecho "$($GREEN)Psensor already installed"
	else
		cho '\n' | sudo apt-add-repository ppa:jfi/ppa
	    sudo apt-get update
	    sudo apt-get install psensor
		echo "$($RED)Psensor is now installed but you need to manually configure it to show up in panel."
	fi
	#########################
	## WHATSAPP ##
	#########################


fi
