import requests
import time
import random

# List of URLs for load balancing
urls = ["http://localhost:80"]

def get_best_url():
    # Implement logic to select URL based on load metrics
    # Placeholder for actual metric-based logic
    return random.choice(urls)

def send_request(url):
    try:
        response = requests.get(url)
        return response
    except requests.RequestException as e:
        print(f"An error occurred: {e}")
        return None

while True:
    url = get_best_url()
    response = send_request(url)
    if response:
        print(f"Response from {url}: {response.status_code} - {response.text}")
    
    time.sleep(0.0001)  # Adjust the sleep time based on your needs
