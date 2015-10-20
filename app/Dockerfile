FROM python:2.7
ENV PYTHONUNBUFFERED 1

# Ensure we have django user with which uwsgi will run.
RUN useradd -ms /bin/bash django

# Install Python dependencies
RUN mkdir -p /src/app/
COPY requirements.txt /src/app/
RUN su -c "pip install -r /src/app/requirements.txt" django

CMD /src/app/bin/uwsgi --ini /src/app/uwsgi.ini
