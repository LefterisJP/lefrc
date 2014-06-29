#!/usr/bin/python2

import gnomekeyring as gk


def get_password(name):
    keyring = 'login'
    keyItems = gk.list_item_ids_sync(keyring)
    for keyItem in keyItems:
        key = gk.item_get_info_sync(keyring, keyItem)
        if key.get_display_name() == name:
            return key.get_secret()
