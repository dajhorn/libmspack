/* macros.c:  libmspack macro kludges for Open Watcom v2.
 *
 * Copyright 2024 Darik Horn <dajhorn@gmail.com>.
 *
 * libmspack is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License (LGPL) version 2.1
 *
 * For further details, see the file COPYING.LIB distributed with libmspack.
 */

#include <inttypes.h>
#include <stdio.h>
#include "macros.h"

uint32_t EndGetI32(unsigned char *buffer)
{
       uint32_t shim32 = 0;

//printf("BORK1 EndGetI32 0=%u 1=%u 2=%u 3=%u\n", buffer[0] & 0xFF, buffer[1] & 0xFF, buffer[2] & 0xFF, buffer[3] & 0xFF); 

       shim32 |= buffer[3] & 0xFF;
       shim32 <<= 8;
       shim32 |= buffer[2] & 0xFF;
       shim32 <<= 8;
       shim32 |= buffer[1] & 0xFF;
       shim32 <<= 8;
       shim32 |= buffer[0] & 0xFF;

//printf("BORK2 shim32=%lu\n", shim32);

       return shim32;
}

uint16_t EndGetI16(unsigned char *buffer)
{
        uint16_t shim16 = 0;

        shim16 |= buffer[1];
        shim16 <<= 8;
        shim16 |= buffer[0];

        return shim16;
}
