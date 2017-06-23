
uri01:=https://www.youtube.com/channel
uri81:=

UCcBXM1hhamn9Su_bEQ1lVzA:=政論郭寶勝
UCO3pO3ykAUybrjv3RBbXEHw:=郭文贵
UC2VwgzDzUNvfRDqQ6LJxTXA:=《平论》
UC3lyWHqUY9IiP4en5jnY6vA:=MingjingTV
UCeBfK3zzgqDQLhBovmguOuQ:=唐柏桥
UCUTYYuGRa_Xzu0FlcM1UvHQ:=透視中國
UCEtI-CRaNx6kiXMrVjnXe8w:=Lee洪宽
UCHjTK8jOPMM3zIz_y8lwNXA:=Gang_Liu
UCdKyM0XmuvQrD0o5TNhUtkQ:=Mingjing_Huopai


uri81 += UC2VwgzDzUNvfRDqQ6LJxTXA
uri81 += UCO3pO3ykAUybrjv3RBbXEHw

uri81 += UCcBXM1hhamn9Su_bEQ1lVzA
uri81 += UC3lyWHqUY9IiP4en5jnY6vA
uri81 += UCeBfK3zzgqDQLhBovmguOuQ
uri81 += UCUTYYuGRa_Xzu0FlcM1UvHQ
uri81 += UCEtI-CRaNx6kiXMrVjnXe8w
uri81 += UCHjTK8jOPMM3zIz_y8lwNXA
uri81 += UCdKyM0XmuvQrD0o5TNhUtkQ



all :help01

help01:
	@echo
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


rate:=16k
freq:=24000
cmd01:=LC_CTYPE=en_US.UTF-8 \
	nice -n 19 \
	youtube-dl   \
	--ignore-errors   \
	--no-check-certificate   \
	-o '%(upload_date)s_%(title)s_%(id)s.%(ext)s' \
	--no-overwrites \
	--prefer-ffmpeg \
	--no-post-overwrites  \
	$$(XX1) \
	-v \
	--exec 'ld_rename_opus2ogg_delete_space_genOGG.sh {} xx $$(XX2) ' 
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
	cd $(1) && touch 00_$(1).ogg && touch zz_$(1).ogg
	-cd $(1) && $(cmd01)  "$(uri01)/$(1)"
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
	nice -n 19 git push -u origin master
#	nice -n 19 git push 
gs:
	nice -n 19 git status
gc:
	nice -n 19 git commit -a
t1:
	       make $(uri81) XX=$(XX)
	@echo "make $(uri81) XX=$(XX)"
#	make UCEtI-CRaNx6kiXMrVjnXe8w

ao audio_only :
	@echo 'BEGIN1 == $@'
	make t1 XX=aoo
	@echo 'END1 == $@'
vo video_only :
	@echo 'BEGIN1 == $@'
	make t1 XX=voo
	@echo 'END1 == $@'
