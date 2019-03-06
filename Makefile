# Makefile for mrblast-demo
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Wed 24 Jan 2018 05:37:55 PM EST

MASTER?=yarn
DRIVER_MEMORY?=2G
EXECUTOR_MEMORY?=4G
CLASS?=gov.ncbi.blast.mapreduce.app.MapReduceBlast
NUM_EXECUTORS=12
NUM_CORES=4
DB?=/user/camacho/swissprot
NREPEATS?=3
RECSPERMAP?=200000
MODE?=blastp
NAME?=${USER}.$(shell echo ${CLASS} | cut -d . -f 6 ).$(shell echo ${DB} | awk -F/ '{print $$NF}' ).${DRIVER_MEMORY}.${NUM_EXECUTORS}.${EXECUTOR_MEMORY}.${NUM_CORES}

JAR_VERSION=$(shell grep version pom.xml  | grep -v encoding | head -1 | sed 's/<version>//;s,</version>,,' | tr -d ' ')
JAR=target/residue-count-$(JAR_VERSION).jar
JAVA_LOGGING='-Dlog4j.debug=true -Dlog4j.configuration=file://${PWD}/src/test/resources/log4j.properties'

BASEDIR=$(realpath .)

JAVA_SRC=$(shell find src/main/java -type f -name "*.java")

ifdef QUIET
	MAVEN_OPTS=-q
endif

#.PHONY: all
#all: ${JAR}

.PHONY: run_at_gcp
run_at_gcp: ${JAR}
	gcp-utils/run-java-residue-count.sh M Q P R S

.PHONY: run_at_ncbi
run_at_ncbi: ${JAR}
	bin/run-java-residue-count.sh M Q P R S


.PHONY: show_help
show_help: ${JAR}
	spark-submit --master ${MASTER} --queue prod.blast \
		--class ${CLASS} $^ -help -db ${DB}

${JAR}:  ${JAVA_SRC} pom.xml
	mvn ${MAVEN_OPTS} package

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

