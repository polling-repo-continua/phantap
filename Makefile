# Copyright (C) 2019 Diana Dragusin <diana.dragusin@nccgroup.com>
# Copyright (C) 2019 Etienne Champetier <champetier.etienne@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=phantap
PKG_VERSION:=2019.05.30
PKG_RELEASE:=1

PKG_MAINTAINER:=Diana Dragusin <diana.dragusin@nccgroup.com>, \
    Etienne Champetier <champetier.etienne@gmail.com>
PKG_LICENSE:=GPL-3.0-only

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/phantap
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=PhanTap
  PKGARCH:=all
  DEPENDS:=+ebtables +tcpdump +ip-full +luci-ssl +luci-app-openvpn +openvpn-mbedtls +kmod-br-netfilter +kmod-ebtables-ipv4 +@KERNEL_BRIDGE_EBT_SNAT
endef

define Package/phantap-learn-arp
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=PhanTap-learn-arp
  PKGARCH:=all
  DEPENDS:=+tcpdump +ip-full
endef

define Package/phantap-learn
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=PhanTap-learn
  DEPENDS:=+libpcap +ip-full
endef

define Package/phantap/description
  PhanTap
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/phantap/install
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DATA) ./files/etc/hotplug.d/iface/00-phantap $(1)/etc/hotplug.d/iface/00-phantap
	$(INSTALL_DIR) $(1)/etc/hotplug.d/net
	$(INSTALL_DATA) ./files/etc/hotplug.d/net/00-phantap $(1)/etc/hotplug.d/net/00-phantap
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/phantap $(1)/etc/init.d/phantap
	$(INSTALL_DIR) $(1)/etc/sysctl.d
	$(INSTALL_DATA) ./files/etc/sysctl.d/12-phantap.conf $(1)/etc/sysctl.d/12-phantap.conf
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/phantap $(1)/usr/bin/phantap
endef

define Package/phantap-learn/install
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DATA) ./files/etc/hotplug.d/iface/00-phantap-learn $(1)/etc/hotplug.d/iface/00-phantap-learn
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/phantap-learn $(1)/etc/init.d/phantap-learn
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/phantap-learn $(1)/usr/sbin/phantap-learn
endef

define Package/phantap-learn-arp/install
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DATA) ./files/etc/hotplug.d/iface/00-phantap-learn-arp $(1)/etc/hotplug.d/iface/00-phantap-learn-arp
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/phantap-learn-arp $(1)/etc/init.d/phantap-learn-arp
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/phantap-learn-arp $(1)/usr/bin/phantap-learn-arp
endef

$(eval $(call BuildPackage,phantap))
$(eval $(call BuildPackage,phantap-learn))
$(eval $(call BuildPackage,phantap-learn-arp))
