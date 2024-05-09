# my-docs

## Install environment

```bash
conda create -n docs-env python=3.8
conda activate docs-env

# 
pip install poetry
# change the source to tsinghua
poetry source add --priority=primary tsinghua https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/ 
# install all dependencies using poetry
poetry install

```

## local run docs

```bash
mkdocs serve

```

