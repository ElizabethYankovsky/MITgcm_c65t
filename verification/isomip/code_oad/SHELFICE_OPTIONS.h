C $Header: /u/gcmpack/MITgcm/verification/isomip/code_oad/SHELFICE_OPTIONS.h,v 1.1 2013/03/29 23:18:56 heimbach Exp $
C $Name: checkpoint65t $

C     *==========================================================*
C     | SHELFICE_OPTIONS.h
C     | o CPP options file for SHELFICE package.
C     *==========================================================*
C     | Use this file for selecting options within the SHELFICE
C     | package.
C     *==========================================================*

#ifndef SHELFICE_OPTIONS_H
#define SHELFICE_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

#ifdef ALLOW_SHELFICE
C     Package-specific Options & Macros go here

C     allow code for simple ISOMIP thermodynamics
#define ALLOW_ISOMIP_TD

C     allow friction velocity-dependent transfer coefficient
C     following Holland and Jenkins, JPO, 1999
#undef SHI_ALLOW_GAMMAFRICT

#endif /* ALLOW_SHELFICE */
#endif /* SHELFICE_OPTIONS_H */