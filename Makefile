# Makefile for building/running residue counting programs on parquet
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu 07 Mar 2019 02:00:03 PM EST

JAR_VERSION=$(shell grep version pom.xml  | grep -v encoding | head -1 | sed 's/<version>//;s,</version>,,' | tr -d ' ')
JAR=target/residue-count-$(JAR_VERSION).jar
JAVA_LOGGING='-Dlog4j.debug=true -Dlog4j.configuration=file://${PWD}/src/test/resources/log4j.properties'

BASEDIR=$(realpath .)

JAVA_SRC=$(shell find src/main/java -type f -name "*.java")

ifdef QUIET
	MAVEN_OPTS=-q
endif

.PHONY: all
all: run_at_gcp_java run_at_gcp_python 

.PHONY: run_at_gcp_python
run_at_gcp_python:
	gcp-utils/run-python-residue-count.sh M Q P R S

.PHONY: run_at_gcp_java
run_at_gcp_java: ${JAR}
	gcp-utils/run-java-residue-count.sh M Q P R S

# Doesn't work
#.PHONY: run_at_ncbi_java
#run_at_ncbi_java: ${JAR}
#	bin/run-java-residue-count.sh M Q P R S

${JAR}:  ${JAVA_SRC} pom.xml
	mvn ${MAVEN_OPTS} package

runtimes.dat:
	bin/proc-logs.pl < typescript > $@

parquet-search-runtimes.png: runtimes.dat runtimes.gpi
	gnuplot -e "output='$@';data_file='$<'" runtimes.gpi
	cp $@ /home/camacho/

parquet-search-runtimes-killed-worker.png: runtimes.dat runtimes.gpi
	gnuplot -e "output='$@';data_file='$<'" runtimes.gpi
	cp $@ /home/camacho/

.PHONY: unit_test
unit_test: all
	mvn ${MAVEN_OPTS} test

.PHONY: clean
clean:
	-mvn ${MAVEN_OPTS} clean

.PHONY: cleanest
cleanest: clean
	${RM} cscope.files tags

#########################################################################
# Code navigation aids

cscope.files:
	[ -s $@ ] || ack -f --sort-files --cc --cpp --java | xargs realpath > $@

tags: cscope.files
	ctags -L $^

cscope.out: cscope.files
	cscope -bq

vim.paths: cscope.files
	xargs -n1 -I{} dirname {} < $^ | sort -u | sed 's/^/set path+=/' > $@

