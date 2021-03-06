FROM aarch64/alpine:latest 
MAINTAINER Jan Pluskal <jan.pluskal@gmail.com> 

# install frolvlad/alpine-python3

RUN apk add --no-cache build-base libffi-dev openssl-dev


RUN apk add --no-cache python2 python-dev && \
	python2 -m ensurepip && \
	rm -r /usr/lib/python*/ensurepip && \
	pip install --upgrade pip setuptools

# install flexget
RUN apk --no-cache add shadow ca-certificates tzdata && \
	pip install --upgrade --force-reinstall --ignore-installed \
		transmissionrpc python-telegram-bot "flexget" && \
	rm -r /root/.cache

# copy local files
COPY files/ /

# add default volumes
VOLUME /config /data
WORKDIR /config

# expose port for flexget webui
EXPOSE 3539 3539/tcp

# run init.sh to set uid, gid, permissions and to launch flexget
RUN chmod +x /scripts/init.sh
CMD ["/scripts/init.sh"]
