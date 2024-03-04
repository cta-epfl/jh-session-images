# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/minimal-notebook:hub-4.0.2
#ARG BASE_CONTAINER=$OWNER/minimal-notebook
#ARG BASE_CONTAINER=$OWNER/minimal-notebook:python-3.9.13
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    # for cython: https://cython.readthedocs.io/en/latest/src/quickstart/install.html
    build-essential \
    # for latex labels
    cm-super \
    dvipng \
    # for matplotlib anim
    ffmpeg \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}


# ARG LSTCHAIN_VER=0.9.6 
# RUN wget https://raw.githubusercontent.com/cta-observatory/cta-lstchain/v$LSTCHAIN_VER/environment.yml && \
#     conda env update -n base -f environment.yml && \
#     pip install lstchain==$LSTCHAIN_VER && \
#     rm environment.yml

#RUN conda update -n base -c conda-forge conda
RUN conda install -n base -c conda-forge mamba conda
#RUN conda install mamba

ARG GAMMAPY_REVISION=1.2
#RUN pip install git+https://github.com/gammapy/gammapy/@$GAMMAPY_REVISION
RUN curl -o environment.yml https://gammapy.org/download/install/gammapy-${GAMMAPY_REVISION}-environment.yml && \
    #mamba env update -n base -f environment.yml && \
    mamba env create -f environment.yml && \
    rm environment.yml

# Install Python 3 packages
RUN mamba install -c conda-forge --quiet --yes \
    'altair' \
    'beautifulsoup4' \
    'bokeh' \
    'bottleneck' \
    'cloudpickle' \
    'conda-forge::blas=*=openblas' \
    'cython' \
    'dask' \
    'dill' \
    'h5py' \
    'ipympl'\
    'ipywidgets' \
    'jupyter_server>=2.0.0' \
    'matplotlib-base' \
    'numba' \
    'numexpr' \
    'openpyxl' \
    'pandas' \
    'patsy' \
    'protobuf' \
    'pytables' \
    'scikit-image' \
    'scikit-learn' \
    'scipy' \
    'seaborn' \
    'sqlalchemy' \
    'statsmodels' \
    'sympy' \
    'widgetsnbextension'\
    'xlrd' \
    'dask-labextension' \
    'jupyterlab' \
    'pip' \
    'dask-gateway~=2024.1.0' \
    && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN pip install 'ctadata @ git+https://github.com/cta-epfl/ctadata.git@v0.4.6'

    #mamba activate gammapy-${GAMMAPY_REVISION} && \
RUN mamba install -n gammapy-$GAMMAPY_REVISION ipykernel && \
    mamba run -n gammapy-$GAMMAPY_REVISION python -m ipykernel install --user --name gammapy-$GAMMAPY_REVISION --display-name gammapy\ $GAMMAPY_REVISION 
    #mamba run -n gammapy-$GAMMAPY_REVISION python -m ipykernel install --user --name gammapy-$GAMMAPY_REVISION --display-name gammapy\ $GAMMAPY_REVISION 
   

RUN mamba install traitlets==5.9.0 -c conda-forge


# RUN jupyter labextension install dask-labextension 

# RUN jupyter serverextension enable --py --sys-prefix dask_labextension

# Install facets which does not have a pip or conda package at the moment
# WORKDIR /tmp
# RUN git clone https://github.com/PAIR-code/facets.git && \
#     jupyter nbextension install facets/facets-dist/ --sys-prefix && \
#     rm -rf /tmp/facets && \
#     fix-permissions "${CONDA_DIR}" && \
#     fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

# RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
#     fix-permissions "/home/${NB_USER}"

# RUN pip install astropy regions matplotlib scipy\<1.10 

USER ${NB_UID}

ADD dask.yaml /etc/dask/dask.yaml

WORKDIR "${HOME}"
