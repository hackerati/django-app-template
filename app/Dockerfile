FROM python:2.7
ENV PYTHONUNBUFFERED 1
RUN mkdir /opt/app
WORKDIR /opt/app
ADD requirements.txt /opt/app/
RUN pip install -r requirements.txt
ADD . /opt/app/
# python manage.py migrate
