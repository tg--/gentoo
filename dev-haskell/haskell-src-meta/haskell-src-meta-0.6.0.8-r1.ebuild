# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.3

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit base haskell-cabal

DESCRIPTION="Parse source to template-haskell abstract syntax"
HOMEPAGE="http://hackage.haskell.org/package/haskell-src-meta"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/haskell-src-exts-1.16:=[profile?] <dev-haskell/haskell-src-exts-1.17:=[profile?]
	>=dev-haskell/syb-0.1:=[profile?] <dev-haskell/syb-0.5:=[profile?]
	>=dev-haskell/th-orphans-0.5:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6
"

PATCHES=("${FILESDIR}/${PN}-0.6.0.8-ghc-7.10.patch")

src_prepare() {
	base_src_prepare
	cabal_chdeps \
		'th-orphans >= 0.5 && < 0.9' 'th-orphans >= 0.5'
}
