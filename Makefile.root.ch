
NOW_ROOT_FILE_NAME:=$(shell cat Nnow_root_file_name.txt|head -n 1 |awk '{printf $$1}')
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
	cat /etc/resolv.conf > rootY/etc/resolv.conf
	chown -R dyn:dyn rootY/home/dyn
	chroot rootY/ su - dyn
	@echo ; mount |grep rootX ; echo 



new :
	@[ -n "$(T)" ] || ( echo ; echo ; echo 'Usage : ';echo '       make new T=???' ; echo ; echo ; exit 3)
	mv     tmp1/$(T)      srcROOT/ 
	ls  srcROOT/$(T)    > Nnow_root_file_name.txt
kill:
	-ps auxf |grep ^dyn |grep make   									|awk '{print $$2}'|xargs -n 1 kill
	-ps auxf |grep ^dyn |grep ld_rename_opus2ogg_delete_space_genOGG.sh |awk '{print $$2}'|xargs -n 1 kill
	-ps auxf |grep ^dyn |grep ffmpeg 									|awk '{print $$2}'|xargs -n 1 kill
	 ps auxf |grep ^dyn
	@echo ; mount |grep rootX ; echo

speed: rootY/tmp/noW/Loop.log.txt 
	make speedX FF=$<

speed3: rootY/tmp/3/nohup.out
	make speedX FF=$<
speed4: rootY/tmp/4/nohup.out
	make speedX FF=$<



speedX:$(FF)
	[ -n "$(FF)" ] || ( echo ; echo "usaage : make FF=xx" ; echo ; exit 32 )
	PP1=`realpath $(FF)`;\
	PP2=`dirname $${PP1}`;\
	PP3=`basename $${PP2}`;\
	while [ 1 ] ; do \
		echo -n "$${HOSTNAME}:$${PP3}: $$(tail -n 50  $(FF) \
		|grep -i Duration\
		|tail -n 1\
		|sed \
		-e 's;^\s*Duration *: *;;g' \
		-e 's;^\s*DURATION *: *;;g' \
		-e 's;frame\s*=\s*;;g' \
		-e 's;time\s*=\s*;;g' \
		-e 's;\..*$$;;g'  \
		-e 's; \+; ;g') " \
		| tail -n 1 \
		;  \
		echo -n " $$(cat $(FF) |grep -i ' pp4 '|tail -n 1 |awk '{printf $$4}') " ; \
		tail $(FF) \
		| sed -e 's;[\r\n];\n;g' \
		-e 's;frame\s*=\s*;;g' \
		-e 's;time\s*=\s*;;g' \
		|grep bitrate= \
		|tail -n 1 ; \
		sleep 10 ; \
		done

ps:
	ps auxf |grep ^dyn
	@[ ! -f rootY/tmp/noW/Start_stop_log.txt ] || ( echo ; tail -n 3 rootY/tmp/noW/Start_stop_log.txt )
	@[ ! -f rootY/tmp/noW/New_add_gen1.txt   ] || ( echo ; tail -n 3 rootY/tmp/noW/New_add_gen1.txt   )
	@echo ; mount |grep rootX ; echo
	@echo
ll:
	while [ 1 ] ; do \
		tail -n 3 rootY/tmp/noW/Start_stop_log.txt ; \
		echo;echo; \
		tail -n 3 rootY/tmp/noW/New_add_gen1.txt ; \
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

