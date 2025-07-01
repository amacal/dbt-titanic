ARG PYTHON_VERSION="3.13"
FROM mcr.microsoft.com/vscode/devcontainers/python:${PYTHON_VERSION}

ARG DBT_VERSION="1.10.2"
ARG ATHENA_VERSION="1.9.4"

ENV PATH="$PATH:/root/.local/bin"
RUN apt update && apt install pipx bash-completion -y

RUN pipx ensurepath && \
    pipx install dbt-core=="${DBT_VERSION}" && \
    pipx inject dbt-core dbt-core dbt-athena=="${ATHENA_VERSION}" && \
    dbt --version

RUN curl "https://awscli.amazonaws.com/awscli-exe-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m).zip" -o "/tmp/awscliv2.zip" && \
    (cd /tmp && unzip -u awscliv2.zip && sudo ./aws/install && rm -rf aws && rm awscliv2.zip) && \
    aws --version

USER vscode
