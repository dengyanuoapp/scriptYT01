
define EOL


endef


uri01:=https://www.youtube.com/channel
uri81:=


ifeq (,$(wildcard FileSet))
$(error ' FileSet is not exist. ' )
endif

uri81:=$(shell cat FileSet|sed -e 's;[\r\n\t];;g'|grep -v ^gitUSERNAME |grep -v ^$$ | awk -F: '{print $$1}')

$(info ===-= $(uri81) ===)

include ./FileSet
#$(error debuging)


all : README.md help01 showHHtop

help01:
	@echo
	@echo "  New_add_gen1.txt "
	@echo "  Cpu_limit.txt    "
	@echo "  skip_kill.txt"
	@echo "  pid_now_yt.txt"
	@echo "  stop.txt_loop"
	@echo "  stop.txt_person"
	@echo "  /tmp/cpu_limit.txt # write the percent init it"
	@echo "  /tmp/cpu_sleep.txt # write the sleep lengh"
	@echo
	@echo "c clean : $(xxYT)"
	@echo
	@echo "vo video_only :"
	@echo "ao audio_only :"
	@echo
	@echo "loopAO        :"
	@echo "loopVO        :"
	@echo "loopAO3       :"
	@echo "loopVO3       :"
	@echo "loopAO180     :"
	@echo "loopVO180     :"
	@echo "vo_before_201708     :"
	@echo "vo_after_20170801    :"
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
# if no specified , video & audio
XX1:=
XX2:=vooaoo
endif
endif

DDstr1:=-d '+16 hour'    
DDstr2:=+%Y%m%d__%H%M%p
DDstr3:=date $(DDstr1) $(DDstr2)

ifneq (,$(DD))
DD11:=$(shell date -d '+2     day'  +%Y%m%d)
DD12:=$(shell date -d '-$(DD) day'  +%Y%m%d)
DD00:=$(shell $(DDstr3))

DD21:= --datebefore $(DD11)
DD22:= --dateafter $(DD12)
endif

## befor MM1 = 201707 -->>> befor 20170701
ifneq (,$(MM1))
DD11:=$(shell date -d '$(MM1)01'  +%Y%m%d)

DD21:= --datebefore $(DD11)
DD22:= 
endif

## befor MM2 = 201707 -->>> after 20170630
ifneq (,$(MM2))
DD12:=$(shell date -d '$(MM2)01 - 1 day'  +%Y%m%d)

DD21:= 
DD22:= --dateafter $(DD12)
endif

## after MM3 = 20170701 , befor MM4 20170731
ifneq (,$(MM3))
DD22:= --dateafter $(MM3)
DD21:= --datebefore $(MM4)
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

	[ ! -f stop.txt_person ] || (echo ; echo "11 stop.txt_person met, exit " ; echo ; )
	[ ! -f stop.txt_person ] || exit 23

	#cd $(1) && ld_youtube_dl2.sh  "$(uri01)/$(1)"
	cd $(1) && touch 00_$($(1)).ogg && touch zz_$($(1)).ogg
	-cd $(1) && ( \
		$(cmd01)  "$(uri01)/$(1)" & pid1=$$$$! ; \
		echo $$$${pid1} > ../pid_now_yt.txt ; \
		wait $$$${pid1} ; sleep 8 )
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

$(info === XX : $(XX) )
$(info === XX1 : $(XX1) )
$(info === XX2 : $(XX2) )
$(info === DD : $(DD) )
$(info === DD21:$(DD21) )
$(info === DD22:$(DD22) )
$(info === MM1:$(MM1) )
$(info === MM2:$(MM2) )
$(info === MM3:$(MM3) )
$(info === MM4:$(MM4) ===-=)

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
	       make $(uri81) XX=$(XX)  DD=$(DD) &> Loop.log.txt 
	@echo "make $(uri81) XX=$(XX)  DD=$(DD) &> Loop.log.txt "
	wc -l New_add_gen1.txt   >> Start_stop_log.txt
	#nice -n 17       git gc --aggressive 
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
ao180:
	echo "`date` : `date +%s` : BEGIN $@"
	make ao DD=180
	echo "`date` : `date +%s` : END $@"
vo180:
	echo "`date` : `date +%s` : BEGIN $@"
	make vo DD=180
	echo "`date` : `date +%s` : END $@"

vo_before_201708:
	echo "`date` : `date +%s` : BEGIN $@"
	make vo MM1=201708
	echo "`date` : `date +%s` : END $@"

vo_after_20170801:
	echo "`date` : `date +%s` : BEGIN $@"
	make vo MM2=201708
	echo "`date` : `date +%s` : END $@"

ifeq (1,0)
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
ldXX += ld_rename_opus2ogg_delete_space_highQuality.sh
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
endif

du1:
	@$(foreach aa1,$(uri81),du -sh $(aa1)/ $(EOL))
loopLOOP:
	while [ 1 ] ; do make c  ; make $(LOOP) ; \
		[ -f stop.txt_loop ] && echo && echo "stop.txt_loop met, exit " && echo && exit 32 ; \
		aa1="$$(cat New_add_gen1.txt|wc -l)" ; \
		[ "$${aa1}" = '0' ] && sleep 13m || sleep 6m ; \
		done ; echo
loopAO:
	make loopLOOP LOOP=ao
loopVO:
	make loopLOOP LOOP=vo
loopAO3:
	make loopLOOP LOOP=ao3
loopVO3:
	make loopLOOP LOOP=vo3
loopAO180:
	make loopLOOP LOOP=ao180
loopVO180:
	make loopLOOP LOOP=vo180

list:
	find -type f |grep -v README.md |grep -v gitignore |grep -v '/.\.txt'|sed -e 's;$$;\n;g'   > 1.txt
gr git_reset_to_remote:
	git fetch origin
	git reset --hard origin/master
	git branch --set-upstream-to=origin/master master

AOVO:
	rm -f `find -name "yy_*.txt"`
	@echo "make t1 XX=$(aovo1)o MM3=$(aovo2)  MM4=$(aovo3) "
	       make t1 XX=$(aovo1)o MM3=$(aovo2)  MM4=$(aovo3)  

#	make vo MM2=201708
#	make vo MM2=201708 ONCE=1
define AOVOtemplate1
$(eval MMav0:=$(3)$(4)$(5))
$(eval MMav1:=$$(shell date -d '$(MMav0) - 0  day' +%Y%m%d ))
$(eval MMav2:=$$(shell date -d '$(MMav0) + 16 day' +%Y%m%d ))
$(1)$(3)$(4)$(5) :
	@echo "<$$@>--"
	@echo "while [ 1 ] ; do make AOVO aovo1=$(2) aovo2=$(MMav1)  aovo3=$(MMav2) && sleep 5m || sleep 12m ; [ -z \"$(ONCE)\" ] || exit ; done"
	@      while [ 1 ] ; do make AOVO aovo1=$(2) aovo2=$(MMav1)  aovo3=$(MMav2) && sleep 5m || sleep 12m ; [ -z  "$(ONCE)"  ] || exit ; done 

endef

monthS:=01 02 03 04 05 06 07 08 09 10 11 12
monthS:=12 11 10 09 08 07 06 05 04 03 02 01
yearS:=2016 2017 2018
yearS:=2018 2017 2016

AoHHxx:=
VoHHxx:=
xx1:=$(foreach yy1,$(yearS),$(foreach mm2,$(monthS),\
$(eval AoHHxx += Ao_$(yy1)$(mm2)01 Ao_$(yy1)$(mm2)16 )\
$(eval VoHHxx += Vo_$(yy1)$(mm2)01 Vo_$(yy1)$(mm2)16 )\
$(eval $(call AOVOtemplate1,Ao_,ao,$(yy1),$(mm2),01))\
$(eval $(call AOVOtemplate1,Ao_,ao,$(yy1),$(mm2),16))\
$(eval $(call AOVOtemplate1,Vo_,vo,$(yy1),$(mm2),01))\
$(eval $(call AOVOtemplate1,Vo_,vo,$(yy1),$(mm2),16))\
))

export AoHHxx
export VoHHxx


define AoVoSH
#!/bin/sh

for aa1 in \$(EOL)\
$(foreach bb1,$1,$(bb1) \$(EOL))
do
	echo "=== $${aa1} start "
	if [ 2 = 2 ] 
	then
		rsync -a --delete /scriptYT01/vvvv/   $${aa1}/ 
		( 
		cd $${aa1}/ 
		make
		git init
		git add .
		git commit -m "first commit $${aa1}"
		git remote add origin https://github.com/youtube01/$${aa1}.git
		[ -z "$$1" ] || sed -i -e "s;/github.com;/youtube01:$$1@github.com;g" .git/config
		)
	else
		make -C $${aa1} $${aa1} ONCE=1
	fi
	echo "=== $${aa1} end "
	echo 'grep github `find . -name config`'
done

endef

AoSH:=$(call AoVoSH,$(AoHHxx))
VoSH:=$(call AoVoSH,$(VoHHxx))
export AoSH
export VoSH



showHHtop:
	@echo showHHvo showHHvoX
	@echo showHHao showHHaoX
showHHao:
	@echo =---- AoHHxx 1
	@for aa1 in $(AoHHxx) ; do echo $${aa1} ; done
	@echo =---- AoHHxx 2
showHHvo:
	@echo =---- VoHHxx 1
	@for aa1 in $(VoHHxx) ; do echo $${aa1} ; done
	@echo =---- VoHHxx 2

showHHaoX:
	@echo "$${AoSH}" > 1.txt
	@echo ; echo 'see  1.txt for details.' ; echo
showHHvoX:
	@echo "$${VoSH}" > 2.txt
	@echo ; echo 'see  2.txt for details.' ; echo



.PHONY: $(uri81)
