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
"""Build rules and transitions for firmware."""

def _stm32_transition_impl(settings, attr):
    # buildifier: disable=unused-variable
    _ignore = attr
    return {
        "//command_line_option:platforms": "//targets:stm32",
        "@pigweed//pw_boot:backend": "@pigweed//pw_boot_cortex_m",
        "@pigweed//pw_assert:backend": "@pigweed//pw_assert_basic",
        "@pigweed//pw_assert:backend_impl": "@pigweed//pw_assert_basic:impl",
        "@pigweed//pw_assert:check_backend": "@pigweed//pw_assert_basic",
        "@pigweed//pw_assert:check_backend_impl": "@pigweed//pw_assert_basic:impl",
        "@pigweed//pw_log:backend": "@pigweed//pw_log_basic",
        "@pigweed//pw_log:backend_impl": "@pigweed//pw_log_basic:impl",
        "@pigweed//pw_sys_io:backend": "@pigweed//pw_sys_io_baremetal_stm32f429",
    }

_stm32_transition = transition(
    implementation = _stm32_transition_impl,
    inputs = [],
    outputs = [
        "//command_line_option:platforms",
        "@pigweed//pw_boot:backend",
        "@pigweed//pw_assert:backend",
        "@pigweed//pw_assert:backend_impl",
        "@pigweed//pw_assert:check_backend",
        "@pigweed//pw_assert:check_backend_impl",
        "@pigweed//pw_log:backend",
        "@pigweed//pw_log:backend_impl",
        "@pigweed//pw_sys_io:backend",
    ],
)

def _binary_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.symlink(output = out, target_file = ctx.executable.binary)
    return [DefaultInfo(files = depset([out]), executable = out)]

# TODO(tpudlik): Replace this with platform_data when it is available.
stm32_cc_binary = rule(
    _binary_impl,
    attrs = {
        "binary": attr.label(
            doc = "cc_binary to build for stm32",
            cfg = _stm32_transition,
            executable = True,
            mandatory = True,
        ),
        "_allowlist_function_transition": attr.label(default = "@bazel_tools//tools/allowlists/function_transition_allowlist"),
    },
)

def _atsam_s7x_transition_impl(settings, attr):
    # buildifier: disable=unused-variable
    _ignore = attr
    return {
        "//command_line_option:platforms": "//targets:atsam_s7x",
        "@pigweed//pw_boot:backend": "@pigweed//pw_boot_cortex_m",
        "@pigweed//pw_assert:backend": "@pigweed//pw_assert_basic",
        "@pigweed//pw_assert:backend_impl": "@pigweed//pw_assert_basic:impl",
        "@pigweed//pw_assert:check_backend": "@pigweed//pw_assert_basic",
        "@pigweed//pw_assert:check_backend_impl": "@pigweed//pw_assert_basic:impl",
        "@pigweed//pw_log:backend": "@pigweed//pw_log_basic",
        "@pigweed//pw_log:backend_impl": "@pigweed//pw_log_basic:impl",
        # "@pigweed//pw_sys_io:backend": "@pigweed//pw_sys_io_baremetal_stm32f429",
    }

_atsam_s7x_transition = transition(
    implementation = _atsam_s7x_transition_impl,
    inputs = [],
    outputs = [
        "//command_line_option:platforms",
        "@pigweed//pw_boot:backend",
        "@pigweed//pw_assert:backend",
        "@pigweed//pw_assert:backend_impl",
        "@pigweed//pw_assert:check_backend",
        "@pigweed//pw_assert:check_backend_impl",
        "@pigweed//pw_log:backend",
        "@pigweed//pw_log:backend_impl",
        # "@pigweed//pw_sys_io:backend",
    ],
)

# TODO(dpemmons): Replace this with platform_data when it is available.
atsam_s7x_cc_binary = rule(
    _binary_impl,
    attrs = {
        "binary": attr.label(
            doc = "cc_binary to build for atsam_s7x",
            cfg = _atsam_s7x_transition,
            executable = True,
            mandatory = True,
        ),
        "_allowlist_function_transition": attr.label(default = "@bazel_tools//tools/allowlists/function_transition_allowlist"),
    },
)

