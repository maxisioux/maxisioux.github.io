---
template: post.html
title: How to add Alembic migrations to an existing FastAPI + Ormar project
date: 2024-05-13
authors:
  - Maxi Sioux
tags: python mkdocs mkdocstrings
# hide: [toc]
---

This is a summary information, ah ah ah ah

<!--more-->

# Topic1

> tip2 this is a note that xxxxxx

!!! tip "Learn more"
    See the [documentation on supported types](../../about/about.md).

TIP: **Changed in version 0.15.**
Linking to any Markdown heading used to be the default, but now opt-in is required.

> NOTE: **Resources on YAML.** YAML can sometimes be a bit tricky, particularly on indentation. Here are some resources that other users found useful to better understand YAML's peculiarities.
>
> - [YAML idiosyncrasies](https://docs.saltproject.io/en/3000/topics/troubleshooting/yaml_idiosyncrasies.html)
> - [YAML multiline](https://yaml-multiline.info/)

WARNING: Since *mkdocstrings* 0.19, the YAML `rendering` key is merged into the `options` key.

# mkdocstrings usage

???+ example "Performance Example - Pydantic vs. dedicated code"
    _(This example requires Python 3.9+)_

    ```python
    from typing import Annotated, Dict, List, Literal, Tuple

    from annotated_types import Gt

    from pydantic import BaseModel


    class Fruit(BaseModel):
        name: str  # (1)!
        color: Literal["red", "green"]  # (2)!
        weight: Annotated[float, Gt(0)]  # (3)!
        bazam: Dict[str, List[Tuple[int, bool, float]]]  # (4)!


    print(
        Fruit(
            name="Apple",
            color="red",
            weight=4.2,
            bazam={"foobar": [(1, True, 0.1)]},
        )
    )
    # > name='Apple' color='red' weight=4.2 bazam={'foobar': [(1, True, 0.1)]}
    ```

??? example "Performance Example - Pydantic vs. dedicated code"
    In general, dedicated code should be much faster that a general-purpose validator, but in this example Pydantic is >300% faster than dedicated code when parsing JSON and validating URLs.

    ```python
    import json
    import timeit
    from urllib.parse import urlparse

    import requests

    from pydantic import HttpUrl, TypeAdapter

    reps = 7
    number = 100
    r = requests.get("https://api.github.com/emojis")
    r.raise_for_status()
    emojis_json = r.content


    def emojis_pure_python(raw_data):
        data = json.loads(raw_data)
        output = {}
        for key, value in data.items():
            assert isinstance(key, str)
            url = urlparse(value)
            assert url.scheme in ("https", "http")
            output[key] = url


    emojis_pure_python_times = timeit.repeat(
        "emojis_pure_python(emojis_json)",
        globals={
            "emojis_pure_python": emojis_pure_python,
            "emojis_json": emojis_json,
        },
        repeat=reps,
        number=number,
    )
    print(f"pure python: {min(emojis_pure_python_times) / number * 1000:0.2f}ms")
    # > pure python: 5.32ms

    type_adapter = TypeAdapter(dict[str, HttpUrl])
    emojis_pydantic_times = timeit.repeat(
        "type_adapter.validate_json(emojis_json)",
        globals={
            "type_adapter": type_adapter,
            "HttpUrl": HttpUrl,
            "emojis_json": emojis_json,
        },
        repeat=reps,
        number=number,
    )
    print(f"pydantic: {min(emojis_pydantic_times) / number * 1000:0.2f}ms")
    # > pydantic: 1.54ms

    print(
        f"Pydantic {min(emojis_pure_python_times) / min(emojis_pydantic_times):0.2f}x faster"
    )
    # > Pydantic 3.45x faster
    ```

!!! example "Example with the Python handler"
    A comments here if you need.

    === "docs/my_page.md"
        ```md
        # Documentation for `MyClass`

        ::: my_package.my_module.MyClass
            handler: python
            options:
              members:
                - method_a
                - method_b
              show_root_heading: false
              show_source: false
        ```

    === "mkdocs.yml"
        ```yaml
        nav:
          - "My page": my_page.md
        ```

    === "src/my_package/my_module.py"
        ```python
        class MyClass:
            """Print print print!"""

            def method_a(self):
                """Print A!"""
                print("A!")

            def method_b(self):
                """Print B!"""
                print("B!")

            def method_c(self):
                """Print C!"""
                print("C!")
        ```

    === "Result"
        <h3 id="documentation-for-myclass" style="margin: 0;">Documentation for <code>MyClass</code></h3>
        <div><div><p>Print print print!</p><div><div>
        <h4 id="mkdocstrings.my_module.MyClass.method_a">
        <code class="highlight language-python">
        method_a<span class="p">(</span><span class="bp">self</span><span class="p">)</span> </code>
        </h4><div>
        <p>Print A!</p></div></div><div><h4 id="mkdocstrings.my_module.MyClass.method_b">
        <code class="highlight language-python">
        method_b<span class="p">(</span><span class="bp">self</span><span class="p">)</span> </code>
        </h4><div><p>Print B!</p></div></div></div></div></div>

It is also possible to integrate a mkdocstrings identifier into a Markdown header:

!!! example
    ```yaml title="mkdocs.yml"
    plugins:
    - mkdocstrings:
        enabled: !ENV [ENABLE_MKDOCSTRINGS, true]
        custom_templates: templates
        default_handler: python
        handlers:
          python:
            options:
              show_source: false
    ```

    The handlers global configuration can then be overridden by local configurations:

    ```yaml title="docs/some_page.md"
    ::: my_package.my_module.MyClass
        options:
          show_source: true
    ```

=== "Markdown"
    ```md
    With a custom title:
    [`Object 1`][full.path.object1]

    With the identifier as title:
    [full.path.object2][]
    ```

=== "HTML Result"
    ```html
    <p>With a custom title:
    <a href="https://example.com/page1#full.path.object1"><code>Object 1</code></a><p>
    <p>With the identifier as title:
    <a href="https://example.com/page2#full.path.object2">full.path.object2</a></p>
    ```
