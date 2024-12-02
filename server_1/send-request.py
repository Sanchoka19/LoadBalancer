import requests
import time

# The URL of your Docker container
url = "http://localhost:8181"

while True:
    try:
        response = requests.get(url)
        print(f"Response status code: {response.status_code}")
        print(f"Response text: {response.text}")
    except requests.RequestException as e:
        print(f"An error occurred: {e}")

    # Wait for 2 seconds before sending the next request
    time.sleep(0.5)
