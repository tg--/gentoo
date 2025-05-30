# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Linux Point-to-Point Tunnelling Protocol Server"
HOMEPAGE="https://poptop.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/poptop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="gre-extreme-debug tcpd"

RDEPEND="net-dialup/ppp:=
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
	elibc_musl? ( net-libs/ppp-defs )"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	# configure.in is actually configure.ac
	mv configure.in configure.ac || die

	# Automake 1.13 compatibility, bug #469476
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADER/' configure.ac || die 'sed on configure.ac failed'

	# remove 'missing' script to prevent warnings
	rm missing || die 'remove missing script failed'

	# respect compiler, bug #461722
	tc-export CC

	local PATCHES=(
		"${FILESDIR}/${P}-gentoo.patch"
		"${FILESDIR}/${P}-sandbox-fix.patch"
		"${FILESDIR}/${P}-pidfile.patch"
		"${FILESDIR}/${P}-libdir.patch"
		"${FILESDIR}/${P}-musl.patch"
		"${FILESDIR}/${P}-c99.patch"
		"${FILESDIR}/${P}-logwtmp.patch"
	)

	if has_version -d ">=net-dialup/ppp-2.5.0"; then
		# https://bugs.gentoo.org/904877
		PATCHES+=( "${FILESDIR}/${P}-ppp-2.5.0.patch" )
	fi

	# Call to default src_prepare to apply patches
	default

	eautoreconf
}

src_configure() {
	use gre-extreme-debug && append-cppflags "-DLOG_DEBUG_GRE_ACCEPTING_PACKET"
	econf \
		--enable-bcrelay \
		$(use tcpd && echo "--with-libwrap")
}

src_compile() {
	emake COPTS="${CFLAGS}"
}

src_install() {
	default

	insinto /etc
	doins samples/pptpd.conf

	insinto /etc/ppp
	doins samples/options.pptpd

	newinitd "${FILESDIR}/pptpd-init-r2" pptpd
	newconfd "${FILESDIR}/pptpd-confd" pptpd

	dodoc README.*
	dodoc -r samples
}
