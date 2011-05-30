# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="python? 2:2.7"
inherit eutils cmake-utils multilib python

DESCRIPTION="A powerful utility to debug OpenGL and Direct3D graphics applications and drivers, and easily capture the graphics API calls, analyze them and playback traces"
HOMEPAGE="https://github.com/apitrace/apitrace"
SRC_URI="https://github.com/apitrace/apitrace/tarball/${PV}/apitrace-${P}-0-g5f03103.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python qt4"

DEPEND="qt4? ( =x11-libs/qt-gui-4.7*
		>=dev-libs/qjson-0.7.1 )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PN}-5f03103"

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	#use multilib && cmake -H. -Bbuild32 -DCMAKE_C_FLAGS=-m32 -DCMAKE_CXX_FLAGS=-m32 -DCMAKE_LINK_FLAGS=-m32 -DCMAKE_INSTALL_LIBDIR=lib32

	#local mycmakeargs="${mycmakeargs}
	#    $(cmake-utils_use qt4 APITRACE_BUILD_GUI)"

	cmake-utils_src_configure
}

#src_compile() {
#	use multilib && make -C build32 glxtrace
#
#	make -C build
#}

src_install() {
	dodoc README TODO || die

	exeinto /usr/bin || die
	doexe ${CMAKE_BUILD_DIR}/glretrace || die
	doexe ${CMAKE_BUILD_DIR}/tracedump || die
	if use qt4 ; then
		doexe ${CMAKE_BUILD_DIR}/qapitrace || die
	fi

	dolib.so ${CMAKE_BUILD_DIR}/glxtrace.so || die
	dolib.a ${CMAKE_BUILD_DIR}/libtrace.a || die
	#use multilib && dolib.so build32/glxtrace.so
}
