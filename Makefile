DESTDIR:=
PREFIX:=usr
INITCPIO:=lib/initcpio

.PHONY: install

install:
	install -D -m 0644 -T tailscale_hook "$(DESTDIR)/$(PREFIX)/$(INITCPIO)/hooks/ntfy"
	install -D -m 0644 -T tailscale_install "$(DESTDIR)/$(PREFIX)/$(INITCPIO)/install/ntfy"
	install -D -m 0644 -T mkinitcpio-ntfy.conf "$(DESTDIR)/etc/ntfy/mkinitcpio-ntfy.conf"