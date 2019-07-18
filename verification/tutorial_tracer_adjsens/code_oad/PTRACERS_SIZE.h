C $Header: /u/gcmpack/MITgcm/verification/tutorial_tracer_adjsens/code_oad/PTRACERS_SIZE.h,v 1.1 2013/03/21 18:44:33 jahn Exp $
C $Name: checkpoint65t $

#ifdef ALLOW_PTRACERS

CBOP
C    !ROUTINE: PTRACERS_SIZE.h
C    !INTERFACE:
C #include PTRACERS_SIZE.h
 
C    !DESCRIPTION:
C Contains passive tracer array size (number of tracers).

C PTRACERS_num defines how many passive tracers are allocated/exist.
C  and is set here (default 1)
C
C     Number of tracers
      INTEGER PTRACERS_num
      PARAMETER(PTRACERS_num = 1 )

#ifdef ALLOW_AUTODIFF_TAMC
c daiwei      INTEGER    iptrkey
      INTEGER    maxpass
      PARAMETER( maxpass     = PTRACERS_num + 2 )
#endif

CEOP
#endif /* ALLOW_PTRACERS */

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
