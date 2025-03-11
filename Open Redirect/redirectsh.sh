#!/bin/bash


ALLOWED_DOMAIN="https://ex.rogki.ru"
TEST_URL="https://ex.rogki.ru/redir/https://ptsecurity.com"

response=$(curl -s -I -L --max-redirs 0 "$TEST_URL" 2>&1)

if [[ $? -ne 0 ]]; then
    echo "Ошибка при выполнении запроса: $response"
    exit 1
fi

location=$(echo "$response" | grep -i "Location:" | head -n1 | cut -d':' -f2- | xargs)

if [[ "$location" == "$ALLOWED_DOMAIN"* ]]; then
    echo "Перенаправление корректное: $location"
else
    echo "Обнаружено некорректное перенаправление: $location"
fi