FROM gcr.io/google.com/cloudsdktool/cloud-sdk:358.0.0-alpine

ARG KUBECTL_VERSION=1.22.0
ARG HELM_VERSION=3.6.3
ARG HELM_DIFF_VERSION=3.1.3
ARG HELMFILE_VERSION=0.140.0

# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates git bash curl jq

ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN chmod +x /usr/local/bin/kubectl

ADD https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz /tmp

RUN tar -zxvf /tmp/helm* -C /tmp \
    && mv /tmp/linux-amd64/helm /bin/helm \
    && rm -rf /tmp/* \
    && helm plugin install https://github.com/databus23/helm-diff --version ${HELM_DIFF_VERSION}

ADD https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 /bin/helmfile

RUN chmod 0755 /bin/helmfile

CMD ["/usr/local/bin/helmfile", "--help"]
