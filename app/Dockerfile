FROM python:3.5
ENV PYTHONUNBUFFERED 1

# Install Python dependencies
RUN mkdir -p /src/app/
COPY requirements.txt /src/app/
RUN pip install -r /src/app/requirements.txt

# Ensure we have django user with which uwsgi will run.
RUN useradd -ms /bin/bash django

CMD uwsgi --ini /src/app/uwsgi.ini
