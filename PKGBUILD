# Maintainer: SilverX <serainox@gmail.com>
pkgname=tesserae-git
_repo=Tesserae
pkgver=r5.20d415a
pkgrel=1
pkgdesc="Free-canvas TUI dashboards in Go: log/exec/http sources, regex rules, live editor"
arch=('x86_64' 'aarch64')
url="https://github.com/Szmelc-INC/Tesserae"
license=('MIT')
makedepends=('git' 'go')
provides=('tesserae')
conflicts=('tesserae')
options=('!debug')
source=("git+$url.git")
sha256sums=('SKIP')

pkgver() {
  cd "$_repo"
  ( set -o pipefail
    git describe --long --tags --abbrev=7 2>/dev/null | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g' ||
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)" )
}

prepare() {
  cd "$_repo"
  export GOPATH="$srcdir/gopath" GOFLAGS="-modcacherw"
  go mod download
}

build() {
  cd "$_repo"
  export GOPATH="$srcdir/gopath" CGO_ENABLED=0 GOFLAGS="-trimpath -mod=readonly -modcacherw"
  go build -ldflags "-s -w" -o tesserae .
}

check() {
  cd "$_repo"
  export GOPATH="$srcdir/gopath" GOFLAGS="-mod=readonly -modcacherw"
  HOME="$srcdir" go test ./...
}

package() {
  cd "$_repo"
  install -Dm755 tesserae "$pkgdir/usr/bin/tesserae"
  install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
  install -Dm644 configs/examples/*.toml -t "$pkgdir/usr/share/doc/$pkgname/examples/"
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
