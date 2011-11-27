# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils linux-info

DESCRIPTION="The spacenavd daemon provides free alternative to the 3dxserv daemon."
HOMEPAGE="http://spacenav.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/spacenav/files/spacenav%20daemon/spacenavd%20${PV}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X debug"

RDEPEND="X? ( x11-apps/xdpyinfo )"
DEPEND="${RDEPEND}"

pkg_setup() {
	CONFIG_CHECK="~HOTPLUG"
	ERROR_CFG="Your kernel needs HOTPLUG for the spacenavd to work properly"
	check_extra_config
}
src_prepare() {
	epatch "${FILESDIR}"/${P}-destdir.patch
	epatch "${FILESDIR}"/${P}-custom-flags.patch
}

src_configure() {
	econf \
		--enable-opt --enable-ldopt \
		$(use_enable X x11) \
		$(use_enable debug)
}

src_install() {
	# Config file
	newconfd "${S}/doc/example-spnavrc" spnavrc

	# Init script
	newinitd "${FILESDIR}/spnavd" spnavrc

	# Daemon
	exeinto /usr/bin
	doexe "${S}/spacenavd"
	use X && doexe "${S}/spnavd_ctl"
}

pkg_postinst() {
	elog "To start the Spacenav daemon system-wide by default"
	elog "you should add it to the default runlevel :"
	elog "\`rc-update add spnavd default\`"
	elog
	if use X; then
		elog "To start generating Spacenav X events by default"
		elog "you should add this command in your user startup"
		elog "scripts such as .gnomerc or .xinitrc :"
		elog "\`spnav_ctl x11 start\`"
		elog
	fi
	ewarn "You must restart spnavd \`/etc/init.d/spnavd restart\` to run"
	ewarn "the new version of the daemon."
}
