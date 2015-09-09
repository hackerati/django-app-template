FROM python:2.7
ENV PYTHONUNBUFFERED 1
RUN mkdir /opt/app
WORKDIR /opt/app
ADD requirements.txt /opt/app/
RUN pip install -r requirements.txt
ADD . /opt/app/
# python manage.py migrate
# python manage.py collectstatic

# Ensure we have django user which owns /opt/app/ directory.
RUN useradd -ms /bin/bash django
RUN chown -R django:django /opt/app/

# Create run/ directory inside /opt/app/ for uwsgi to communicate via socket.
RUN test -d /opt/app/run/ || mkdir -p /opt/app/run/

CMD ["uwsgi", "--ini", "uwsgi.ini"]
