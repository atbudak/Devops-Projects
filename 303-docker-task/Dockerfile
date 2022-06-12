FROM python:3.9-slim as build 
LABEL maintainer="Adem Budak"

RUN apt-get update 
RUN apt-get install -y --no-install-recommends \ 
    build-essential gcc
RUN pip install flask


COPY ./app /usr/app
WORKDIR /usr/app
RUN python -m venv /usr/app/venv
ENV PATH="/usr/app/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

FROM python:3.9-slim
RUN groupadd -g 2000 python-app && \
    useradd -r -u 2000 -g python-app python-app

RUN mkdir /usr/app && chown python-app:python-app /usr/app
WORKDIR /usr/app

COPY --chown=python-app:python-app --from=build /usr/app/venv ./venv
COPY --chown=python-app:python-app . .

USER 2000

ENV PATH="/usr/app/venv/bin:$PATH"
CMD [ "gunicorn" , "--workers", "2", "--threads", "2", "--bind", "0.0.0.0:5000", "app:app"]