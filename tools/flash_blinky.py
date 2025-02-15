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
"""Flash the echo binary to a connected STM32 Discovery Board.

Usage:
  bazel run //tools:flash
"""

import subprocess

from rules_python.python.runfiles import runfiles
from serial.tools import list_ports

_BINARY_PATH = "__main__/src/blinky.elf"
_OPENOCD_PATH = "openocd/bin/openocd"
_OPENOCD_CONFIG_PATH = "__main__/targets/same70/atsame70q20b/openocd_atsame70q20b.cfg"

def flash():
  r = runfiles.Create()
  openocd = r.Rlocation(_OPENOCD_PATH)
  binary = r.Rlocation(_BINARY_PATH)
  openocd_cfg = r.Rlocation(_OPENOCD_CONFIG_PATH)

  print(f"binary Rlocation is: {binary}")
  print(f"openocd Rlocation is: {openocd}")
  print(f"openocd config Rlocation is: {openocd_cfg}")

  assert binary is not None
  assert openocd_cfg is not None

  # Variables referred to by the OpenOCD config.
  env = {
      # "PW_STLINK_SERIAL": board_serial,
      # "PW_GDB_PORT": "disabled",
  }

  subprocess.check_call(
      [
          openocd,
          "-f",
          f"{openocd_cfg}",
          "-c",
          f"program {binary} reset exit",
      ],
      env=env,
  )

  ## here's what's used by west:
  # openocd \
  # -s /home/dpemmons/zephyr-quickstart/third_party/zephyr/boards/duet3d/duet3_mb6hc/support 
  # -s /home/dpemmons/opt/zephyr-sdk-0.16.8/sysroots/x86_64-pokysdk-linux/usr/share/openocd/scripts 
  # -f /home/dpemmons/zephyr-quickstart/third_party/zephyr/boards/duet3d/duet3_mb6hc/support/openocd.cfg 
  # '-c init' 
  # '-c targets' 
  # -c 'reset init' 
  # -c 'flash write_image erase /home/dpemmons/zephyr-quickstart/build/zephyr/zephyr.hex' 
  # -c 'atsamv gpnvm set 1' 
  # -c 'reset run' 
  # -c shutdown

if __name__ == "__main__":
  flash()
