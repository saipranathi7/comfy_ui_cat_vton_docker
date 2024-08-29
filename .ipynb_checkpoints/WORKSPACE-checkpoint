load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.0/bazel-skylib-1.4.0.tar.gz"],
    sha256 = "f24ab666394232f834f74d19e2ff142b0af17466ea0c69a3f4c276ee75f6efce",
)

local_repository(
    name = "io_bazel_rules_docker",
    path = "rules_docker-0.23.0",  # Ensure this path is correct
)

load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_push")
