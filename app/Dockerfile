FROM python:2.7
ENV PYTHONUNBUFFERED 1

# Install Python dependencies
RUN mkdir -p /src/app/
COPY requirements.txt /src/app/
RUN virtualenv /src/app/env
RUN /src/app/env/bin/pip install -r /src/app/requirements.txt

# Ensure we have django user with which uwsgi will run.
RUN useradd -ms /bin/bash django

CMD /src/app/bin/uwsgi --ini /src/app/uwsgi.ini
