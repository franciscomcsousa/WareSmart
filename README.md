# Ambient Inteligence

## Backend

### Python virtual environment

- To create virtual environment:

    ```$ python3.11 -m venv .venv```

- To activate virtual environment

    ```$ source .venv/bin/activate```

- To install pip packages:

    ```$ pip install -r requirements.txt```

- To exit virtual environment:

    ```$ deactivate```

### Reverse proxy

- Nginx file:
```
$ cat /etc/nginx/sites-available/smart_storage 
server {
  listen 80;
  listen [::]:80;
  
  # server_name IP_ADDRESS; # Change this field to the machine IP address
  
  location / {
    proxy_pass http://127.0.0.1:8000/;
  }
}
```

- **Note** - Create a link of the previous file to `sites-enabled` (remove the default one aswell):

    ```$ ln -s ../sites-available/smart_storage smart_storage```

## Frontend

- To enter the environment:

    ```$ cd frontend/application```

- To run the aplication:
    ```$ flutter run```