import requests


def say_hello(name: str) -> str:
    url = f"http://example-server:8004/?name={name}"
    response = requests.get(url)
    return response.text


if __name__ == "__main__":
    print(say_hello("James"))
