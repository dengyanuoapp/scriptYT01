
define EOL


endef


uri01:=https://www.youtube.com/channel
uri81:=


ifeq (,$(wildcard FileSet))
$(error ' FileSet is not exist. ' )
endif

uri81:=$(shell cat FileSet|sed -e 's;[\r\n\t];;g'|grep -v ^gitUSERNAME |grep -v ^$$ | awk -F: '{print $$1}')

$(info === $(uri81) ===)

include ./FileSet
#$(error debuging)


all : README.md help01

help01:
	@echo
	@echo "  New_add_gen1.txt "
	@echo "  Cpu_limit.txt    "
	@echo "  skip_kill.txt"
	@echo "  pid_now_yt.txt"
	@echo
	@echo "c clean : $(xxYT)"
	@echo
	@echo "vo video_only :"
	@echo "ao audio_only :"
	@echo
	@echo "loopAO3       :"
	@echo

m :
	vim Makefile

PWD01:=$(shell [ -f /bin/realpath ] &&  /bin/realpath    .)
PWD02:=$(shell [ -f /bin/readlink ] &&  /bin/readlink -m .)
PWD03:=$(firstword $(wildcard $(PWD01) $(PWD02)))
ifeq (,$(PWD03))
$(error ' path error ')
endif

PWD11:=$(shell [ -f /bin/basename ] &&  /bin/basename $(PWD03))

#gitUSERNAME:=youtube01

gitHUB:=https://github.com

# https://github.com/youtube01/newest03/tree/master/UC3lyWHqUY9IiP4en5jnY6vA
gitTOP0:=$(gitHUB)/$(gitUSERNAME)/$(PWD11)
gitTOP1:=$(gitHUB)/$(gitUSERNAME)/$(PWD11)/tree/master
gitTOP2:=$(gitHUB)/$(gitUSERNAME)/$(PWD11)/commits/master
$(info --- gitHUB --- $(gitHUB) --- )
$(info --- gitUSERNAME --- $(gitUSERNAME) --- )
$(info --- PWD11 --- $(PWD11) --- )
$(info --- gitTOP1 --- $(gitTOP1) --- )

README.md : FileSet
	[ -f readme.head ] && cat readme.head > $@ || echo -n > $@
	echo >> $@; echo >> $@ 
	echo "# $(gitTOP2)   # updateing " >> $@ $(EOL) 
	echo >> $@; echo >> $@
	$(foreach aa1,$(uri81),\
		echo "# $(gitTOP1)/$(aa1)              # --> $($(aa1))" >> $@ $(EOL) \
		echo >> $@ $(EOL))

#	--postprocessor-args \
#	' -vn -acodec opus -f opus -ac 1 -maxrate $(rate) -ar $(freq) -ab $(rate) '   \
#	--exec 'ld_rename_opus2ogg_delete_space.sh {}' 

ifeq ($(XX),aoo)
XX1:=-x
XX2:=aoo
else
ifeq ($(XX),voo)
XX1:=
XX2:=voo
else
XX1:=-x
XX2:=
endif
endif

DDstr1:=-d '+16 hour'    
DDstr2:=+%Y%m%d__%H%M%p
DDstr3:=date $(DDstr1) $(DDstr2)

ifneq (,$(DD))
DD11:=$(shell date                  +%Y%m%d)
DD12:=$(shell date -d '-$(DD) day'  +%Y%m%d)
DD00:=$(shell $(DDstr3))

DD21:= --datebefore $(DD11)
DD22:= --dateafter $(DD12)
endif


rate:=16k
freq:=24000
cmd01:=LC_CTYPE=en_US.UTF-8 \
	nice -n 19 \
	youtube-dl   \
	--abort-on-unavailable-fragment    \
	--force-ipv4  \
	--ignore-errors   \
	--no-check-certificate   \
	-o '%(upload_date)s_%(title)s_%(id)s.%(ext)s' \
	--no-overwrites \
	--prefer-ffmpeg \
	--no-post-overwrites  \
	-v \
	$$(DD21)  \
	$$(DD22)  \
	--exec 'ld_rename_opus2ogg_delete_space_genOGG.sh {} $$(XX2) '   \
	$$(XX1) 
obj01:= "https://www.youtube.com/watch?v=CYi6Ir9nKOY"
obj01:= "https://www.youtube.com/watch?v=UNuNTcMu_Vk"
obj01:= "https://www.youtube.com/watch?v=ozvjYzyW7Uc"
t2:
	$(cmd01) \
		$(obj01)



#$(foreach aa1,$(uri81),$(eval $(call 
define YTtemplate1
$(eval dd$(1):=$(1))
$(eval ddYT += dd$(1))
$(eval xx$(1):=$(1)/yy_$($(1)).txt)
$(eval xxYT += $(xx$(1)))
$(1): $(xx$(1))
$(xx$(1)):
	mkdir -p $(1)/
	#cd $(1) && ld_youtube_dl2.sh  "$(uri01)/$(1)"
	cd $(1) && touch 00_$($(1)).ogg && touch zz_$($(1)).ogg
	-cd $(1) && ( $(cmd01)  "$(uri01)/$(1)" & pid1=$$$$! ; echo $$$${pid1} > ../pid_now_yt.txt ; wait $$$${pid1} ; sleep 8 )
	touch $$@

endef
YTube=$(info $(foreach mm1,$1, $(eval $(call YTtemplate1,$(mm1)))))


#uri81:=UCEtI-CRaNx6kiXMrVjnXe8w
$(call YTube,$(uri81))

ifeq (1,0)
$(info --- $(xxYT) -- 0 --- )
$(info --- $(foreach aa1,$(xxYT),$($(aa1))) --1--- )
$(info --- $(foreach aa1,$(ddYT),$($(aa1))) --2--- )
endif


c clean : 
	rm -f $(wildcard $(xxYT)) 

up:
	nice -n 15 git push -u origin master
#	nice -n 15 git push 
gs:
	nice -n 15 git status
gc:
	nice -n 15 git commit -a
gd:
	nice -n 15 git diff
t1:
	echo -n > New_add_gen1.txt
	       make $(uri81) XX=$(XX)  DD=$(DD) 
	@echo "make $(uri81) XX=$(XX)  DD=$(DD)  "
#	make UCEtI-CRaNx6kiXMrVjnXe8w

ao audio_only :
	@echo "BEGIN1 == `date` : `date +%s` $@ : `$(DDstr3)` " ;echo "BEGIN1 == `date` : `date +%s` $@ : `$(DDstr3)` "   >> Start_stop_log.txt
	make t1 XX=aoo DD=$(DD)
	@echo "END1   == `date` : `date +%s` $@ : `$(DDstr3)` " ;echo "END1   == `date` : `date +%s` $@ : `$(DDstr3)` "   >> Start_stop_log.txt
vo video_only :
	@echo "BEGIN1 == `date` : `date +%s` $@ : `$(DDstr3)` " ;echo "BEGIN1 == `date` : `date +%s` $@ : `$(DDstr3)` "   >> Start_stop_log.txt
	make t1 XX=voo DD=$(DD)
	@echo "END1   == `date` : `date +%s` $@ : `$(DDstr3)` " ;echo "END1   == `date` : `date +%s` $@ : `$(DDstr3)` "   >> Start_stop_log.txt

ao3:
	echo "`date` : `date +%s` : BEGIN $@"
	make ao DD=2
	echo "`date` : `date +%s` : END $@"
vo3:
	echo "`date` : `date +%s` : BEGIN $@"
	make vo DD=2
	echo "`date` : `date +%s` : END $@"

ifneq (,$(wildcard ld_/))
ldXX :=
#ldXX += ld_ffmpeg_1_origin.sh
#ldXX += ld_ffmpeg_2_aac.sh
#ldXX += ld_ffmpeg_3_mp2.sh
#ldXX += ld_ffmpeg_4_opus.sh
#ldXX += ld_ffmpeg_5_ogg01.sh
#ldXX += ld_ffmpeg_6_ogg02.sh
#ldXX += ld_ffmpeg_7_mp4.sh
ldXX += ld_rename_opus2ogg_delete_space_genOGG.sh
ldXX += ld_rename_opus2ogg_delete_space_noGEN.sh
ldXX += ld_run.sh
ldXX += ld_youtube_dl1__video.sh
ldXX += ld_youtube_dl2__audio.sh

define LDtemplate1
$(eval $(1)1:=ld_/$(1))
$(eval $(1)2:=/bin/$(1))
$(eval ldYY += $($(1)1))
$($(1)1): $($(1)2)
	cp $$^ $$@

endef

$(eval $(foreach ld1,$(ldXX), $(eval $(call LDtemplate1,$(ld1)))))
#$(info --- $(ldYY) )

ld : $(ldYY)
#	echo $^
else
ld :
	@echo ; echo ' no ld target exist.' ; echo
endif

du1:
	@$(foreach aa1,$(uri81),du -sh $(aa1)/ $(EOL))
loopAO3:
	#while [ 1 ] ; do make c  ; make ao3 &> Loop.log.txt ; sleep 30m ; done
	while [ 1 ] ; do make c  ; make ao3 &> Loop.log.txt ; \
		[ -f stop.txt ] && echo && echo "stop.txt met, exit " && echo && break ; \
		aa1="$$(cat New_add_gen1.txt|wc -l)" ; \
		[ "$${aa1}" = '0' ] && sleep 3m || sleep 6m ; \
		done ; echo
list:
	find -type f |grep -v README.md |grep -v gitignore |grep -v '/.\.txt'|sed -e 's;$$;\n;g'   > 1.txt
