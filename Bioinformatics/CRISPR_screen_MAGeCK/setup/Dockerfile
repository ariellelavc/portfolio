# Initialize a new bild stage and
# set the base image for subsequent instructions
FROM davidliwei/mageck
LABEL authors="lac"

# Setup the environment of the new container
COPY ./environment.yml /

# Install conda in the new container
RUN INSTALL_PATH=~/anaconda \
    && wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest* -fbp $INSTALL_PATH 

# Set the PATH variable in the  
ENV PATH /root/anaconda/bin:$PATH

RUN conda env create -f /environment.yml && conda clean -a

ENV PATH /root/anaconda/envs/crispr/bin:$PATH








