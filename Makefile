include $(TOPDIR)/rules.mk

PKG_NAME:=ua2u
PKG_VERSION:=0.0
PKG_RELEASE:=1

PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILE:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/ua2u
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Routing and Redirection
  TITLE:=Change User-Agent to Fwords
  URL:=https://github.com/Jntmkk/ua2u
  DEPENDS:=+ipset +iptables-mod-conntrack-extra +iptables-mod-nfqueue \
    +libnetfilter-conntrack +libnetfilter-queue
endef

define Package/ua2u/description
  Change User-agent to Fwords to prevent being checked by Dr.Com.
endef

EXTRA_LDFLAGS += -lmnl -lnetfilter_queue -lipset

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(EXTRA_LDFLAGS) \
		$(PKG_BUILD_DIR)/ua2u.c -o $(PKG_BUILD_DIR)/ua2u
endef

define Package/ua2u/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ua2u $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/config $(1)/etc/init.d $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/etc/config/ua2u.config $(1)/etc/config/ua2u
	$(INSTALL_BIN) ./files/etc/init.d/ua2u.init $(1)/etc/init.d/ua2u
	# $(INSTALL_BIN) ./files/etc/config/ua2u.uci $(1)/etc/uci-defaults/80-ua2u
endef

define Package/ua2u/postinst
#!/bin/sh

# check if we are on real system
[ -n "$${IPKG_INSTROOT}" ] || {
	(. /etc/uci-defaults/80-ua2u) && rm -f /etc/uci-defaults/80-ua2u
	exit 0
}
endef

$(eval $(call BuildPackage,ua2u))