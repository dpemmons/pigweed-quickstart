#include <cstddef>
#include <string_view>

#include "same70n20b.h"

// LED functions

void pc18_init(void) {
  port_registers_t* port_regs = (port_registers_t*)PORT_REGS;
  port_regs->GROUP[2].PORT_OUTSET = PORT_OUTSET_OUTSET(PORT_PC18);
  port_regs->GROUP[2].PORT_DIRSET = PORT_DIRSET_DIRSET(PORT_PC18);
}

void pc18_LED_on(void) {
  port_registers_t* port_regs = (port_registers_t*)PORT_REGS;
  port_regs->GROUP[2].PORT_OUTCLR = PORT_OUTCLR_OUTCLR(PORT_PC18);
}

void pc18_LED_off(void) {
  port_registers_t* port_regs = (port_registers_t*)PORT_REGS;
  port_regs->GROUP[2].PORT_OUTSET = PORT_OUTSET_OUTSET(PORT_PC18);
}

void pc18_LED_toggle(void) {
  port_registers_t* port_regs = (port_registers_t*)PORT_REGS;
  port_regs->GROUP[2].PORT_OUTTGL = PORT_OUTTGL_OUTTGL(PORT_PC18);
}

void pc06_init(void) {
  port_registers_t* port_regs = (port_registers_t*)PORT_REGS;
  port_regs->GROUP[2].PORT_OUTSET = PORT_OUTSET_OUTSET(PORT_PC06);
  port_regs->GROUP[2].PORT_DIRSET = PORT_DIRSET_DIRSET(PORT_PC06);
}

void pc06_LED_on(void) {
  port_registers_t* port_regs = (port_registers_t*)PORT_REGS;
  port_regs->GROUP[2].PORT_OUTCLR = PORT_OUTCLR_OUTCLR(PORT_PC06);
}

void pc06_LED_off(void) {
  port_registers_t* port_regs = (port_registers_t*)PORT_REGS;
  port_regs->GROUP[2].PORT_OUTSET = PORT_OUTSET_OUTSET(PORT_PC06);
}

void pc06_LED_toggle(void) {
  port_registers_t* port_regs = (port_registers_t*)PORT_REGS;
  port_regs->GROUP[2].PORT_OUTTGL = PORT_OUTTGL_OUTTGL(PORT_PC06);
}

int main() {
  pc18_init();
  pc06_init();
  size_t cnt = 0;
  constexpr size_t kCntMax = 5000000;
  while (1) {
    if (((cnt++) % kCntMax) == 0) {
      pc18_LED_toggle();
      pc06_LED_toggle();
    }
  }
  return 0;
}