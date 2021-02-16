FROM debian:stable
ARG ARCHITECTURE=amd64

RUN apt-get update
RUN apt-get install -y python3 python3-pip bash openssl python3-lxml
COPY requirements.txt /root/pyschool-requirements.txt
RUN pip3 install -r /root/pyschool-requirements.txt
RUN jupyter contrib nbextensions install
#RUN jupyter nbextensions_configurator enable
RUN jupyter nbextension enable freeze/main && jupyter nbextension enable hide_input/main
RUN jupyter nbextension disable nbextensions_configurator/config_menu/main
RUN jupyter notebook --generate-config
COPY server/jupyter_notebook_config.py /root/.jupyter/
COPY server/startup.sh /
COPY server/init.sh /
RUN chmod +x /init.sh && chmod +x /startup.sh
COPY jupyter /var/www/jupyter
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini-${ARCHITECTURE} /bin/tini
RUN chmod +x /bin/tini

ENTRYPOINT ["/bin/tini", "--"]
CMD ["/startup.sh"]
