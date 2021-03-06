FROM alpine:edge

MAINTAINER Danny Chan <a@b.c>

RUN apk update && \
	apk add --no-cache --update bash && \
	mkdir -p /aria2/conf && \
	mkdir -p /aria2/conf-copy && \
	mkdir -p /aria2/data && \
	apk add --no-cache --update aria2 && \
	apk add git && \
	git clone https://github.com/ziahamza/webui-aria2 /aria2/aria2-webui && \
	rm /aria2/aria2-webui/.git* -rf && \
    	apk del git && \
	apk add --update darkhttpd

ENV PROJECT_DIR /aria2/conf-copy
WORKDIR $PROJECT_DIR

COPY files/docker-entrypoint.sh $PROJECT_DIR
COPY files/aria2.conf $PROJECT_DIR
COPY files/on-complete.sh $PROJECT_DIR

RUN chmod +x ./docker-entrypoint.sh

ENV SECRET SECRET

VOLUME ["/aria2/data"]
VOLUME ["/aria2/conf"]

EXPOSE 6800 80 8080

#RUN addgroup -g 1000 -S aria && \
#    adduser -u 1000 -S aria -G aria

#USER aria

#HEALTHCHECK --interval=60s --timeout=120s --start-period=30s \
CMD ["./docker-entrypoint.sh"]
#ENTRYPOINT ["./docker-entrypoint.sh"]
