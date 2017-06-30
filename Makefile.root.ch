
NOW_ROOT_FILE_NAME:=$(shell cat now_root_file_name.txt|head -n 1 |awk '{printf $$1}')
#$(info $(NOW_ROOT_FILE_NAME))

all: help01
	@echo ; mount |grep rootX ; echo


e extract:$(NOW_ROOT_FILE_NAME)
	[ -d  rootY/ ] || mkdir rootY/
	make um
	rm -fr rootY/*
	cd rootY && tar xfJ  ../$< ; echo
	chmod -R a-s rootY
	chmod -R a-s rootY/

m :
	vim Makefile
help01:
	@echo 
	@echo ' e         extract '
	@echo ' ch        chroot  '
	@echo ' um        umount  '
	@echo ' mm        mmount  '
	@echo ' new       new_rootfs  '
	@echo 
	@echo 
um : 
	-umount rootY/dev/
	-umount Data01/ 
	-umount rootY/tmp/
	@echo ; mount |grep rootX ; echo 
mm mmount :
	grep -q /home/rootX/rootY/dev /proc/mounts  || mount -t devtmpfs none rootY/dev/
	grep -q /home/rootX/rootY/tmp /proc/mounts  || mount -o bind,uid=dyn,gid=dyn Data01/ rootY/tmp/
	-[ -d rootY/tmp/1        ] || mkdir rootY/tmp/1         
	#-[ -d rootY/tmp/scriptS  ] || mkdir rootY/tmp/scriptS         
	-chown -R dyn:dyn rootY/tmp rootY/scriptYT01/
	@echo ; mount |grep rootX ; echo
ch        chroot  : mm
#	chroot rootY/
	chroot rootY/ su - dyn
	@echo ; mount |grep rootX ; echo 



new :
	@[ -n "$(T)" ] || ( echo ; echo ; echo 'Usage : ';echo '       make new T=???' ; echo ; echo ; exit 3)
	mv     tmp1/$(T)      srcROOT/ 
	ls  srcROOT/$(T)    > now_root_file_name.txt
kill:
	-ps auxf |grep ^dyn |grep make   |awk '{print $$2}'|xargs -n 1 kill
	-ps auxf |grep ^dyn |grep ffmpeg |awk '{print $$2}'|xargs -n 1 kill
	 ps auxf |grep ^dyn
	@echo ; mount |grep rootX ; echo

ps:
	ps auxf |grep ^dyn
	@[ ! -f tmpn/Start_stop_log.txt ] || ( echo ; tail -n 3 tmpn/Start_stop_log.txt )
	@[ ! -f tmpn/New_add_gen1.txt   ] || ( echo ; tail -n 3 tmpn/New_add_gen1.txt   )
	@echo ; mount |grep rootX ; echo
	@echo
ll:
	while [ 1 ] ; do \
		tail -n 3 tmpn/Start_stop_log.txt ; \
		echo;echo; \
		tail -n 3 tmpn/New_add_gen1.txt ; \
		echo;echo; \
		sleep 30 ; \
		done

cpu:
	[ -f /proc/cpuinfo ] || ( echo ; echo 'cpuinfo do NOT exist. exit.' ; echo ;echo ; exit 33 )
	[ "$${USER}" = 'dyn' ] || ( echo ; echo 'yould should run by dyn only.' ;echo ; exit 44 )
	while [ 1 ] ; do \
		sleep 1 ; \
		sh rootY/scriptYT01/Cpu_limit.sh `nc -l  127.0.0.1 33778 ` ; \
	done 
	#	    nc -l  127.0.0.1 33778 |xargs -n 1  cpulimit -l 47  -z -p ; 

