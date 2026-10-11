import requests


def say_hello(name: str) -> str:
    url = f"http://192.168.161.30:30004/?name={name}"
    response = requests.get(url)
    return response.text


if __name__ == "__main__":
    print(say_hello("James"))
