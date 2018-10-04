# 
#                            PUBLIC DOMAIN NOTICE
#               National Center for Biotechnology Information
#
#  This software/database is a "United States Government Work" under the
#  terms of the United States Copyright Act.  It was written as part of
#  the author's official duties as a United States Government employee and
#  thus cannot be copyrighted.  This software/database is freely available
#  to the public for use. The National Library of Medicine and the U.S.
#  Government have not placed any restriction on its use or reproduction.
#
#  Although all reasonable efforts have been taken to ensure the accuracy
#  and reliability of the software and data, the NLM and the U.S.
#  Government do not and cannot warrant the performance or results that
#  may be obtained by using this software or data. The NLM and the U.S.
#  Government disclaim all warranties, express or implied, including
#  warranties of performance, merchantability or fitness for any particular
#  purpose.
#
#  Please cite the author in any work or product based on this material.
#
# =============================================================================
# NCBI BLAST+ Dockerfile
#


FROM ubuntu:16.04
MAINTAINER Christiam Camacho <camacho@ncbi.nlm.nih.gov>
ARG version=2.8.0alpha

USER root
RUN apt-get -y -m update && apt-get install -y \
    wget \
    liblist-moreutils-perl \
    perl-doc

WORKDIR /usr
#RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-x64-linux.tar.gz && \
#    tar xzf ncbi-blast-${version}+-x64-linux.tar.gz --strip-components=1 && \
#    rm ncbi-blast-${version}+-x64-linux.tar.gz
RUN wget https://storage.googleapis.com/christiam-test/ncbi-blast-${version}+-x64-linux.tar.gz && \
    tar xzf ncbi-blast-${version}+-x64-linux.tar.gz --strip-components=1 && \
    rm ncbi-blast-${version}+-x64-linux.tar.gz

RUN mkdir -p /blast/db/blast
ENV BLASTDB /blast/db/blast
WORKDIR /tmp

CMD ["/bin/bash"]
