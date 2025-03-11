#!/bin/bash

# Отправляем запрос и получаем заголовки
response=$(curl -s -I -H "Origin: https://evil.com" "https://ex.rogki.ru")

# Проверяем наличие заголовка
if echo "$response" | grep -qi "Access-Control-Allow-Origin:"; then
    acao_value=$(echo "$response" | grep -i "Access-Control-Allow-Origin:" | head -n1 | cut -d':' -f2- | xargs)
    echo "Потенциальная уязвимость CORS: $acao_value"
else
    echo "CORS-защита корректна."
fi