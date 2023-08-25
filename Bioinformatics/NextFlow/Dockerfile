# Initialize a new build stage and
# set the base image for subsequent instructions
FROM nfcore/base
LABEL authors="lac"

# Setup the environment of the new container
COPY ./environment.yml /

# Create conda environment in the new container on top of base image
RUN conda env create -f /environment.yml && conda clean -a

# Set the PATH variable in the container
ENV PATH /opt/conda/envs/nextflow-rnaseq/bin:$PATH
