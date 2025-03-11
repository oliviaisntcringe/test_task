import requests

HEADERS = {"Origin": "https://evil.com"}
response = requests.get("https://ex.rogki.ru", headers=HEADERS)

if "Access-Control-Allow-Origin" in response.headers:
    print("Потенциальная уязвимость CORS:", response.headers["Access-Control-Allow-Origin"])
else:
    print("CORS-защита корректна.")
