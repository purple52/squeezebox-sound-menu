NULL = 

#Build in these directories:

SUBDIRS = \
	src \
	po \
	$(NULL)

squeezebox_sound_menudocdir = ${prefix}/doc/squeezebox_sound_menu
squeezebox_sound_menudoc_DATA = \
	ChangeLog \
	README \
	COPYING \
	AUTHORS \
	INSTALL \
	NEWS\
	$(NULL)

EXTRA_DIST = \
	$(squeezebox_sound_menudoc_DATA) \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in\
	$(NULL)

DISTCLEANFILES = \
	intltool-extract \
	intltool-merge \
	intltool-update \
	po/.intltool-merge-cache \
	$(NULL)

