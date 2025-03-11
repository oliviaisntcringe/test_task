import requests

# Доверенный домен
ALLOWED_DOMAIN = "https://ex.rogki.ru"
TEST_URL = "https://ex.rogki.ru/redir/https://ptsecurity.com"

try:
    response = requests.get(TEST_URL, allow_redirects=False, timeout=10)
    location = response.headers.get("Location", "")
    if location.startswith(ALLOWED_DOMAIN):
        print("Перенаправление корректное:", location)
    else:
        print("Обнаружено некорректное перенаправление:", location)
except requests.RequestException as e:
    print("Ошибка при выполнении запроса:", e)
