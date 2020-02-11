FROM python:3.8.1

LABEL Author="Greg Reboul"
LABEL E-mail="gregoire.reboul@gmail.com"
LABEL version="0.0.1"

ENV PYTHONDONTWRITEBYTECODE 1
ENV FLASK_APP "app.py"
ENV FLASK_ENV "development"
ENV FLASK_DEBUG True

RUN mkdir /app
WORKDIR /app

COPY Pip* /app/

RUN pip install --upgrade pip && \
    pip install pipenv && \
    pipenv install --dev --system --deploy --ignore-pipfile

ADD . /app

EXPOSE 80

CMD pipenv run flask run --host=0.0.0.0 --port=80