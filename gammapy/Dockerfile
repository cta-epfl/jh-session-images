# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/minimal-notebook:hub-4.0.2
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
    # for wheel
    bison \
    byacc \
    flex \
    zlib1g-dev \
    # for matplotlib anim
    fuse \
    ffmpeg \
    rclone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# Install Python 3 packages
RUN mamba install --quiet --yes \
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
    'healpy' \
    'dask-labextension' \
    'jupyterlab' \
    'pip' \
    'dask-gateway~=2024.1.0' \
    && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN pip install 'ctadata @ git+https://github.com/cta-epfl/ctadata.git@v0.4.6'

ARG GAMMAPY_VERSION
RUN test -n "$GAMMAPY_VERSION"
RUN pip install gammapy==v$GAMMAPY_VERSION astropy regions matplotlib scipy
#RUN mamba install -c conda-forge gammapy=v$GAMMAPY_VERSION # astropy regions matplotlib scipy

# DEPRECATED install way :
# RUN mamba install -c conda-forge dask-labextension && \
#     jupyter labextension install dask-labextension

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


USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
	    yacc flex && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

ADD dask.yaml /etc/dask/dask.yaml

	#scipy\<1.12 astropy\<6 pydantic==1.9
RUN pip install \
		scipy==1.10.1 \
		pandas==1.5.2 \
		astropy==5.3 \
		regions==0.7 \
		iminuit==2.21 \
		naima==0.10 \
		pydantic==2.5 \
		emcee==3.1 
		#sherpa==4.15 \
		#pyyaml==6.0  \
		#click==8.1.3 \
		#numpy==1.24 \
		#matplotlib==3.7 \
		#corner==2.2.1


RUN gammapy --version

WORKDIR "${HOME}"
