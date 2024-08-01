#!/bin/bash

# Обновление системы и установка необходимых пакетов
apt update && apt upgrade -y
apt install -y snapd

# Перезагрузка системы
reboot
