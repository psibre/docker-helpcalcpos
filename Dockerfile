FROM i386/debian:latest
RUN apt-get update && apt-get -y install \
  wget \
  unzip
RUN wget http://www.ag500.de/calcpos/HelpCalcpos.zip
RUN unzip HelpCalcpos
RUN rm -f HelpCalcpos.zip
RUN chmod +x HelpCalcpos/HelpCalcpos
ENV CLIENT localhost
CMD HelpCalcpos/HelpCalcpos $CLIENT
