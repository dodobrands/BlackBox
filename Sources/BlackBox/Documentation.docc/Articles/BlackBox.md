# ``BlackBox/BlackBox``

Entry points for logs.

## Overview

BlackBox takes logs and redirects them to target destinations, such as ``OSLogger`` and ``OSSignpostLogger``.

Each log is processed on background queue so that your app performance won't suffer.

When creating new BlackBox instance you can override default `DispatchQueue` that logs are processed on. If you do so make sure your custom queue is serial, otherwise logs order may be unpredicable.
