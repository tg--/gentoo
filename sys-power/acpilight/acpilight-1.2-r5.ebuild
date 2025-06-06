# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit python-single-r1 udev

MY_P="${PN}-v${PV}"

DESCRIPTION="Replacement for xbacklight that uses the ACPI interface to set brightness"
HOMEPAGE="https://gitlab.com/wavexx/acpilight/"
SRC_URI="https://gitlab.com/wavexx/acpilight/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	!dev-libs/light
	!x11-apps/xbacklight
	acct-group/video
	virtual/udev
"

DOCS=( README.rst NEWS.rst )

PATCHES=( "${FILESDIR}/acpilight-1.2-fix-log10-of-zero.patch" )

# Disable Makefile that installs by default
src_compile() { :; }

src_install() {
	python_doscript xbacklight
	udev_dorules "${S}"/90-backlight.rules
	doman xbacklight.1
	einstalldocs
	newinitd "${FILESDIR}"/acpilight.initd acpilight
	newconfd "${FILESDIR}"/acpilight.confd acpilight
}

pkg_postinst() {
	udev_reload
	elog "To use the xbacklight binary as a regular user, you must be a part of the video group"
	einfo
	elog "If this utility does not find any backlights to manipulate,"
	elog "verify you have kernel support on the device and display driver enabled."
	einfo
	elog "To take advantage of the OpenRC init script, and automate the process of"
	elog "saving and restoring the brightness level you should add acpilight"
	elog "to the boot runlevel. You can do this as root like so:"
	elog "# rc-update add acpilight boot"
	einfo
}

pkg_postrm() {
	udev_reload
}
