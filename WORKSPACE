# Copyright 2023 The Pigweed Authors
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Load Pigweed's own dependencies that we'll need.
#
# TODO: b/274148833 - Don't require users to spell these out.
http_archive(
    name = "platforms",
    sha256 = "8150406605389ececb6da07cbcb509d5637a3ab9a24bc69b1101531367d89d74",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/0.0.8/platforms-0.0.8.tar.gz",
        "https://github.com/bazelbuild/platforms/releases/download/0.0.8/platforms-0.0.8.tar.gz",
    ],
)

http_archive(
    name = "bazel_skylib",  # 2022-09-01
    sha256 = "4756ab3ec46d94d99e5ed685d2d24aece484015e45af303eb3a11cab3cdc2e71",
    strip_prefix = "bazel-skylib-1.3.0",
    urls = ["https://github.com/bazelbuild/bazel-skylib/archive/refs/tags/1.3.0.zip"],
)

http_archive(
    name = "rules_proto",
    sha256 = "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
    strip_prefix = "rules_proto-5.3.0-21.7",
    urls = [
        "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
    ],
)

http_archive(
    name = "rules_python",
    sha256 = "0a8003b044294d7840ac7d9d73eef05d6ceb682d7516781a4ec62eeb34702578",
    strip_prefix = "rules_python-0.24.0",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.24.0/rules_python-0.24.0.tar.gz",
)

load("@rules_python//python:repositories.bzl", "py_repositories")

py_repositories()

http_archive(
    name = "com_google_protobuf",
    sha256 = "c6003e1d2e7fefa78a3039f19f383b4f3a61e81be8c19356f85b6461998ad3db",
    strip_prefix = "protobuf-3.17.3",
    url = "https://github.com/protocolbuffers/protobuf/archive/v3.17.3.tar.gz",
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

# TODO(b/311746469): Switch back to a released version when possible.
git_repository(
    name = "rules_fuzzing",
    commit = "67ba0264c46c173a75825f2ae0a0b4b9b17c5e59",
    remote = "https://github.com/bazelbuild/rules_fuzzing",
)

load("@rules_fuzzing//fuzzing:repositories.bzl", "rules_fuzzing_dependencies")

rules_fuzzing_dependencies()

load("@rules_fuzzing//fuzzing:init.bzl", "rules_fuzzing_init")

rules_fuzzing_init()

git_repository(
    name = "pigweed",
    # ROLL: Warning: this entry is automatically updated.
    # ROLL: Last updated 2024-08-06.
    # ROLL: By https://cr-buildbucket.appspot.com/build/8740398242156414753.
    commit = "d75af95f4e045d8a6aff84fb1082349501783973",
    remote = "https://pigweed.googlesource.com/pigweed/pigweed.git",
)

git_repository(
    name = "pw_toolchain",
    # ROLL: Warning: this entry is automatically updated.
    # ROLL: Last updated 2024-08-06.
    # ROLL: By https://cr-buildbucket.appspot.com/build/8740398242156414753.
    commit = "d75af95f4e045d8a6aff84fb1082349501783973",
    remote = "https://pigweed.googlesource.com/pigweed/pigweed.git",
    strip_prefix = "pw_toolchain_bazel",
)

# Get ready to grab CIPD dependencies. For this minimal example, the only
# dependencies will be the toolchains and OpenOCD (used for flashing).
load(
    "@pigweed//pw_env_setup/bazel/cipd_setup:cipd_rules.bzl",
    "cipd_client_repository",
    "cipd_repository",
)

cipd_client_repository()


load("@pigweed//pw_toolchain:register_toolchains.bzl", "register_pigweed_cxx_toolchains")

register_pigweed_cxx_toolchains()

# Get the OpenOCD binary (we'll use it for flashing).
cipd_repository(
    name = "openocd",
    path = "infra/3pp/tools/openocd/${os}-${arch}",
    tag = "version:2@0.11.0-3",
)

load("@rules_python//python:repositories.bzl", "python_register_toolchains")

# Set up the Python interpreter and PyPI dependencies we'll need.
python_register_toolchains(
    name = "python3",
    python_version = "3.11",
)

load("@python3//:defs.bzl", "interpreter")
load("@rules_python//python:pip.bzl", "pip_parse")

pip_parse(
    name = "pypi",
    python_interpreter_target = interpreter,
    requirements_lock = "//:requirements_lock.txt",
)

load("@pypi//:requirements.bzl", "install_deps")

git_repository(
    name = "cmsis",
    build_file_content = """
cc_library(
  name = "core",
  includes = [ "CMSIS/Core/Include", ],
  hdrs = glob(["CMSIS/Core/Include/*.h"]),
  visibility = ["//visibility:public"]
)
    """,
    # strip_prefix = "CMSIS_5-develop",
    commit = "4a819a09ccadacc3bad2def1d5121f137fc330fb",
    remote = "https://github.com/ARM-software/CMSIS_5"
)

install_deps()
