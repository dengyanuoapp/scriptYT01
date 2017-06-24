
uri01:=https://www.youtube.com/channel
uri81:=


UCyDCC5CcIqMqBbzMVENoKVQ:=趙岩
UCHjTK8jOPMM3zIz_y8lwNXA:=Gang_Liu
UCdKyM0XmuvQrD0o5TNhUtkQ:=Mingjing_Huopai
UCcBXM1hhamn9Su_bEQ1lVzA:=政論郭寶勝
UC2VwgzDzUNvfRDqQ6LJxTXA:=《平论》
UChRE0pMeij_O5FqWrSKBF-Q:=書齋夜話
UCO3pO3ykAUybrjv3RBbXEHw:=郭文贵
UCKt9OVBD71w4eGQEkLdn6NA:=History_Channel_Mingjing
UC6xKvXKdFxPYjZGc5idYycA:=明鏡廣播電台
UCUTYYuGRa_Xzu0FlcM1UvHQ:=透視中國
UCEtI-CRaNx6kiXMrVjnXe8w:=Lee洪宽
UC3lyWHqUY9IiP4en5jnY6vA:=MingjingTV
UCeBfK3zzgqDQLhBovmguOuQ:=唐柏桥

uri81 += UCyDCC5CcIqMqBbzMVENoKVQ
uri81 += UCHjTK8jOPMM3zIz_y8lwNXA
uri81 += UCdKyM0XmuvQrD0o5TNhUtkQ
uri81 += UCcBXM1hhamn9Su_bEQ1lVzA
uri81 += UC2VwgzDzUNvfRDqQ6LJxTXA
uri81 += UChRE0pMeij_O5FqWrSKBF-Q
uri81 += UCO3pO3ykAUybrjv3RBbXEHw
uri81 += UCKt9OVBD71w4eGQEkLdn6NA
uri81 += UC6xKvXKdFxPYjZGc5idYycA
uri81 += UCUTYYuGRa_Xzu0FlcM1UvHQ
uri81 += UCEtI-CRaNx6kiXMrVjnXe8w
uri81 += UC3lyWHqUY9IiP4en5jnY6vA
uri81 += UCeBfK3zzgqDQLhBovmguOuQ



all :help01

help01:
	@echo
	@echo "  New_add_gen1.txt "
	@echo "c clean : $(xxYT)"
	@echo "vo video_only :"
	@echo "ao audio_only :"
	@echo

m :
	vim Makefile


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

ifneq (,$(DD))
DD11:=$(shell date                  +%Y%m%d)
DD12:=$(shell date -d '-$(DD) day'  +%Y%m%d)
DD00:=$(shell date -d '+16 hour'    +%Y%m%d__%H%M%p)

DD21:= --datebefore $(DD11)
DD22:= --dateafter $(DD12)
endif


rate:=16k
freq:=24000
cmd01:=LC_CTYPE=en_US.UTF-8 \
	nice -n 19 \
	youtube-dl   \
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


define EOL


endef


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
	rm -f $(wildcard $(xxYT)) nohup.out

up:
	nice -n 15 git push -u origin master
#	nice -n 15 git push 
gs:
	nice -n 15 git status
gc:
	nice -n 15 git commit -a
t1:
	echo -n > New_add_gen1.txt
	       make $(uri81) XX=$(XX)  DD=$(DD) 
	@echo "make $(uri81) XX=$(XX)  DD=$(DD)  "
#	make UCEtI-CRaNx6kiXMrVjnXe8w

ao audio_only :
	@echo 'BEGIN1 == $@'
	make t1 XX=aoo DD=$(DD)
	@echo 'END1 == $@'
vo video_only :
	@echo 'BEGIN1 == $@'
	make t1 XX=voo DD=$(DD)
	@echo 'END1 == $@'

ao3:
	make ao DD=3
vo3:
	make vo DD=3


ldXX :=
ldXX += ld_ffmpeg_1_origin.sh
ldXX += ld_ffmpeg_2_aac.sh
ldXX += ld_ffmpeg_3_mp2.sh
ldXX += ld_ffmpeg_4_opus.sh
ldXX += ld_ffmpeg_5_ogg01.sh
ldXX += ld_ffmpeg_6_ogg02.sh
ldXX += ld_ffmpeg_7_mp4.sh
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

du1:
	@$(foreach aa1,$(uri81),du -sh $(aa1)/ $(EOL))
