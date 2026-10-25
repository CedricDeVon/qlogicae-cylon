library(reticulate)
py_module <- import_from_path("r", path = "target/binding/")
py_module$square(9.0)  # ➜ 81
