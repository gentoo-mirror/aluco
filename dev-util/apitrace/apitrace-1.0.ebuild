# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="python? 2:2.6"
inherit eutils toolchain-funcs multilib python

DESCRIPTION="A powerful utility to debug OpenGL and Direct3D graphics applications and drivers, and easily capture the graphics API calls, analyze them and playback traces"
HOMEPAGE="https://github.com/apitrace/apitrace"
SRC_URI="https://github.com/apitrace/apitrace/tarball/${PV}/apitrace-${P}-0-g5f03103.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="python" #qt4

RDEPEND=""
#RDEPEND="qt4? ( =x11-libs/qt-gui-4.7*
#		>=dev-libs/qjson-0.5 )"

DEPEND="${RDEPEND}
	=dev-util/cmake-2.8*
	=dev-lang/python-2.6*"

S="${WORKDIR}/${PN}-${PN}-5f03103"

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	cmake -H. -Bbuild
}

src_compile() {
	make -C build
}

src_install() {
	dodoc README TODO || die

	echo $PWD
	exeinto /usr/bin || die
	doexe build/glretrace || die
	doexe build/tracedump || die

	dolib.so build/glxtrace.so || die
	dolib.a build/libtrace.a || die
}
