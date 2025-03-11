#!/bin/bash


GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' 
CHECKMARK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"

# Отправка запроса и захват заголовков
response=$(curl -s -I -H "Origin: https://evil.com" "https://ex.rogki.ru")

# Проверка заголовка
if echo "$response" | grep -qi "Access-Control-Allow-Origin:"; then
    acao_value=$(echo "$response" | grep -i "Access-Control-Allow-Origin:" | head -n1 | cut -d':' -f2- | sed 's/^[[:space:]]*//')
    echo -e "${CROSS} ${RED}Обнаружена потенциальная уязвимость CORS:${NC} $acao_value"
else
    echo -e "${CHECKMARK} ${GREEN}CORS-защита настроена корректно.${NC}"
fi