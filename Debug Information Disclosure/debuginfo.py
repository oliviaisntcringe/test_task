import requests

URL = "https://kakoitosait.ru/api/v1/search?query[]=123"
response = requests.get(URL)

if any(term in response.text.lower() for term in ["stack trace", "bitrix"]):
    print("Обнаружена отладочная информация!")
else:
    print("Все чисто.")
