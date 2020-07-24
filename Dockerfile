FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

# Expose port
EXPOSE 8080

# Update apt-get and python
RUN apt-get update -y && \
    apt-get install -y python3-pip python3

# Copy app source code
WORKDIR /app 
COPY ./app /app

# Install python requirements
COPY ./requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

# Installs equities package
COPY ./package /app/equities
WORKDIR /app/equities
RUN pip3 install -r /app/equities/requirements.txt
RUN python3 setup.py install 

# builds equities universe and exports
WORKDIR /app
RUN python3 ./utils/setup.py 

# Runs flask app inside container
RUN python3 main.py