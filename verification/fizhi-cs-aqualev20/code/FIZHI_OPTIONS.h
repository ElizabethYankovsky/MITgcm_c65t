C $Header: /u/gcmpack/MITgcm/verification/fizhi-cs-aqualev20/code/FIZHI_OPTIONS.h,v 1.4 2012/03/22 14:23:30 jmc Exp $
C $Name: checkpoint65t $

#ifndef FIZHI_OPTIONS_H
#define FIZHI_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

#ifdef ALLOW_FIZHI
C     Package-specific options go here

C     use fixed day in the year:
#define FIZHI_USE_FIXED_DAY

C     use new version of S/R GETPWHERE
#define TRY_NEW_GETPWHERE

#endif /* ALLOW_FIZHI */
#endif /* FIZHI_OPTIONS_H */

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
