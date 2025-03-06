# mkinitcpio-ntfy

This hook sends a notification via [ntfy.sh](https://ntfy.sh/) in early userspace to notify the system admin that the system is (re)booting and is ready for passphrase entry. This hook requires that networking be set up using another mkinitcpio module, like `net` from [`mkinitcpio-nfs-utils`](https://gitlab.archlinux.org/archlinux/packaging/packages/mkinitcpio-nfs-utils) or [`mkinitcpio-rclocal`](https://github.com/ahesford/mkinitcpio-rclocal).

Configuration must be done in `/etc/ntfy/mkinitcpio-ntfy.conf`, which is
sourced as a busybox ash shell script.

- NTFY_SERVER_URL:    Server URL including topic (ie. `https://ntfy.sh/customtopic` or self-hosted URL and topic) - *Required*
- NTFY_MESSAGE:   Custom message - *Required*
- NTFY_DELAY:   Delay before sending notification in seconds (default `10`) *Required*
- NTFY_AUTH_TOKEN: Authentication token (If authentication/ACLs are set) - *Optional*

> Note: This project is not affiliated with ntfy.sh in any way

## Security Considerations

Because the auth token is stored in the initramfs, it may become available to attackers if not stored in an encrypted system.
It is recommended that you use a unique and dedicated token for this, so that if it is ever compromised, it can easily be revoked and replaced.

## Setup

1. Customize the configuration file `/etc/ntfy/mkinitcpio-ntfy.conf` with your details.
3. Add `ntfy` to `HOOKS` and `curl` to `BINARIES` in `/etc/mkinitcpio.conf`, after any network setup hooks.
3. Regenerate the initramfs.

If using the [container build](https://docs.zfsbootmenu.org/en/latest/general/container-building/example.html) of ZfsBootMenu, follow the steps below instead:
1. Follow the instructions to configure basic network access
2. Move the customized configuration file to `/etc/zfsbootmenu/ntfy/ntfy.conf`
3. Add `ntfy` to `HOOKS` and `curl` to `BINARIES` in `/etc/zfsbootmenu/mkinitcpio.conf.d/ntfy.conf`
    ```shell
    cat > /etc/zfsbootmenu/mkinitcpio.conf.d/ntfy.conf <<EOF
    BINARIES+=(curl)
    HOOKS+=(ntfy)
    EOF
    ```
4. Add a script in `/etc/zfsbootmenu/rc.d` to copy the configuration file into the container build environment:
    ```shell
    cat > /etc/zfsbootmenu/rc.d/ntfy <<EOF
    #!/bin/sh

    mkdir -p /etc/ntfy
    cp /build/ntfy/mkinitcpio-ntfy.conf /etc/ntfy/
    EOF

    chmod 755 /etc/zfsbootmenu/rc.d/ntfy
    ```
5. Run `zbm-builder.sh`