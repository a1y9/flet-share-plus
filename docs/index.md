# Introduction

FletSharePlus for Flet.

## Examples

```
import flet as ft

from flet_share_plus import FletSharePlus


def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    page.add(

                ft.Container(height=150, width=300, alignment = ft.alignment.center, bgcolor=ft.Colors.PURPLE_200, content=FletSharePlus(
                    tooltip="My new FletSharePlus Control tooltip",
                    value = "My new FletSharePlus Flet Control", 
                ),),

    )


ft.app(main)
```

## Classes

[FletSharePlus](FletSharePlus.md)


