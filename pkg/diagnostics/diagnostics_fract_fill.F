C $Header: /u/gcmpack/MITgcm/pkg/diagnostics/diagnostics_fract_fill.F,v 1.8 2013/08/14 01:00:11 jmc Exp $
C $Name: checkpoint65t $

#include "DIAG_OPTIONS.h"

CBOP
C     !ROUTINE: DIAGNOSTICS_FRACT_FILL
C     !INTERFACE:
      SUBROUTINE DIAGNOSTICS_FRACT_FILL(
     I               inpFld, fractFld, scaleFact, power, chardiag,
     I               kLev, nLevs, bibjFlg, biArg, bjArg, myThid )

C     !DESCRIPTION:
C***********************************************************************
C   Wrapper routine to increment the diagnostics arrays with a RL field
C           using a scaling factor & square option (power=2)
C           and using a RL fraction-weight (assumed to be the
C           counter-mate of the current diagnostics)
C   Note: 1) fraction-weight has to correspond to the diagnostics
C            counter-mate (filled independently with a call to
C             DIAGNOSTICS_FILL)
C         2) assume for now that inpFld & fractFld are both _RL and
C            have the same horizontal shape (overlap,bi,bj ...)
C***********************************************************************
C     !USES:
      IMPLICIT NONE

C     == Global variables ===
#include "EEPARAMS.h"
#include "SIZE.h"
#include "DIAGNOSTICS_SIZE.h"
#include "DIAGNOSTICS.h"

C     !INPUT PARAMETERS:
C***********************************************************************
C  Arguments Description
C  ----------------------
C     inpFld    :: Field to increment diagnostics array
C     fractFld  :: fraction used for weighted average diagnostics
C     scaleFact :: scaling factor
C     power     :: option to fill-in with the field square (power=2)
C     chardiag  :: Character expression for diag to fill
C     kLev      :: Integer flag for vertical levels:
C                  > 0 (any integer): WHICH single level to increment in qdiag.
C                  0,-1 to increment "nLevs" levels in qdiag,
C                  0 : fill-in in the same order as the input array
C                  -1: fill-in in reverse order.
C     nLevs     :: indicates Number of levels of the input field array
C                  (whether to fill-in all the levels (kLev<1) or just one (kLev>0))
C     bibjFlg   :: Integer flag to indicate instructions for bi bj loop
C                  0 indicates that the bi-bj loop must be done here
C                  1 indicates that the bi-bj loop is done OUTSIDE
C                  2 indicates that the bi-bj loop is done OUTSIDE
C                     AND that we have been sent a local array (with overlap regions)
C                  3 indicates that the bi-bj loop is done OUTSIDE
C                     AND that we have been sent a local array
C                     AND that the array has no overlap region (interior only)
C                  NOTE - bibjFlg can be NEGATIVE to indicate not to increment counter
C     biArg     :: X-direction tile number - used for bibjFlg=1-3
C     bjArg     :: Y-direction tile number - used for bibjFlg=1-3
C     myThid    ::  my thread Id number
C***********************************************************************
C                  NOTE: User beware! If a local (1 tile only) array
C                        is sent here, bibjFlg MUST NOT be set to 0
C                        or there will be out of bounds problems!
C***********************************************************************
      _RL     inpFld(*)
      _RL     fractFld(*)
      _RL     scaleFact
      INTEGER power
      CHARACTER*8 chardiag
      INTEGER kLev, nLevs, bibjFlg, biArg, bjArg
      INTEGER myThid
CEOP

C     !LOCAL VARIABLES:
C     ndId      :: diagnostic Id number (in available diagnostics list)
C     msgBuf    :: Informational/error message buffer
      INTEGER m, n, j, k, l, bi, bj
      INTEGER ndId, ipt, iSp
      INTEGER region2fill(0:nRegions)
      INTEGER mate, nLevFract
      CHARACTER*10 gcode
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      INTEGER arrType
      _RS     dummyRS(1)
C ===============

C--   Check if this S/R is called from the right place ;
C     needs to be after DIAGNOSTICS_SWITCH_ONOFF and before DIAGNOSTICS_WRITE
      IF ( diag_pkgStatus.NE.ready2fillDiags ) THEN
        CALL DIAGNOSTICS_STATUS_ERROR( 'DIAGNOSTICS_FRACT_FILL',
     &                   ' ', chardiag, ready2fillDiags, myThid )
      ENDIF

      arrType = 0
      IF ( bibjFlg.EQ.0 ) THEN
        bi = myBxLo(myThid)
        bj = myByLo(myThid)
      ELSE
        bi = biArg
        bj = bjArg
      ENDIF
C--   2D/3D Diagnostics :
C Run through list of active diagnostics to make sure
C we are trying to fill a valid diagnostic
      DO n=1,nlists
       DO m=1,nActive(n)
        IF ( chardiag.EQ.flds(m,n) .AND. idiag(m,n).GT.0 ) THEN
         ipt = idiag(m,n)
         IF ( ndiag(ipt,bi,bj).GE.0 ) THEN
           ndId = jdiag(m,n)
           ipt = ipt + pdiag(n,bi,bj)*kdiag(ndId)
C-    check for a counter-mate:
           mate = 0
           gcode = gdiag(ndId)(1:10)
           IF ( gcode(5:5).EQ.'C' ) mate = hdiag(ndId)
           IF ( mate.LE.0 ) THEN
             WRITE(msgBuf,'(2A)') 'DIAGNOSTICS_FRACT_FILL: ',
     &            'did not find a valid counter-mate'
             CALL PRINT_ERROR( msgBuf , myThid )
             WRITE(msgBuf,'(2A,I6,2A)') 'DIAGNOSTICS_FRACT_FILL: ',
     &            'for diag(#',ndId,' ) :', chardiag
             CALL PRINT_ERROR( msgBuf , myThid )
             STOP 'ABNORMAL END: S/R DIAGNOSTICS_FRACT_FILL'
           ENDIF
C-    set the nb of levels of fraction-weight field (not > kdiag(mate))
           nLevFract = MIN(nLevs,kdiag(mate))
C-    diagnostic is valid & active, has a counter-mate, do the filling:
           CALL DIAGNOSTICS_FILL_FIELD(
     I              inpFld, fractFld, dummyRS, dummyRS,
     I              scaleFact, power, arrType, nLevFract,
     I              ndId, ipt, kLev, nLevs,
     I              bibjFlg, biArg, bjArg, myThid )
         ENDIF
        ENDIF
       ENDDO
      ENDDO

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
C--   Global/Regional Statistics :

C Run through list of active statistics-diagnostics to make sure
C we are trying to compute & fill a valid diagnostic

      DO n=1,diagSt_nbLists
       DO m=1,diagSt_nbActv(n)
        IF ( chardiag.EQ.diagSt_Flds(m,n) .AND. iSdiag(m,n).GT.0 ) THEN
         iSp = iSdiag(m,n)
         IF ( qSdiag(0,0,iSp,bi,bj).GE.0. ) THEN
           ndId = jSdiag(m,n)
C-    check for a counter-mate:
           mate = 0
           gcode = gdiag(ndId)(1:10)
c          IF ( gcode(5:5).EQ.'C' ) READ(gcode,'(5X,I3)') mate
           IF ( gcode(5:5).EQ.'C' ) mate = hdiag(ndId)
           IF ( mate.LE.0 ) THEN
             WRITE(msgBuf,'(2A)') 'DIAGNOSTICS_FRACT_FILL: ',
     &            'did not find a valid counter-mate'
             CALL PRINT_ERROR( msgBuf , myThid )
             WRITE(msgBuf,'(2A,I6,2A)') 'DIAGNOSTICS_FRACT_FILL: ',
     &            'for diag(#',ndId,' ) :', chardiag
             CALL PRINT_ERROR( msgBuf , myThid )
             STOP 'ABNORMAL END: S/R DIAGNOSTICS_FRACT_FILL'
           ENDIF
C-    set the nb of levels of fraction-weight field (not > kdiag(mate))
           nLevFract = MIN(nLevs,kdiag(mate))
C-    Find list of regions to fill:
           DO j=0,nRegions
            region2fill(j) = diagSt_region(j,n)
           ENDDO
C-    if this diagnostics appears in several lists (with same freq)
C     then add regions from other lists
           DO l=1,diagSt_nbLists
            DO k=1,diagSt_nbActv(l)
             IF ( iSdiag(k,l).EQ.-iSp ) THEN
              DO j=0,nRegions
               region2fill(j) = MAX(region2fill(j),diagSt_region(j,l))
              ENDDO
             ENDIF
            ENDDO
           ENDDO
C-    diagnostics is valid and Active, has a counter mate: Now do the filling
           CALL DIAGSTATS_FILL(
     I              inpFld, fractFld,
#ifndef REAL4_IS_SLOW
     I              dummyRS, dummyRS,
#endif
     I              scaleFact, power, arrType, nLevFract,
     I              ndId, iSp, region2fill, kLev, nLevs,
     I              bibjFlg, biArg, bjArg, myThid )
         ENDIF
        ENDIF
       ENDDO
      ENDDO

      RETURN
      END
