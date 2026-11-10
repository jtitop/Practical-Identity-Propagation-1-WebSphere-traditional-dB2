         TITLE 'DSN3SATH - SAMPLE IDENTIFY AUTHORIZATION EXIT'          00010056
****-START-OF-SPECIFICATIONS-****************************************** 00030000
*                                                                     * 00040000
*   MODULE NAME  = DSN3@ATH                                           * 00050000
*                                                                     * 00060000
*   DESCRIPTIVE                                                       * 00070000
*   NAME         = SAMPLE DB2 IDENTIFY AUTHORIZATION EXIT FOR         * 00080000
*                  RACF ENVIRONMENT.                                  * 00090000
*                                                                     * 00100000
*      Licensed Materials - Property of IBM                           * 00110000
*      5615-DB2                                                       * 00120000
*      (C) COPYRIGHT 1982, 2016 IBM Corp.  All Rights Reserved.       * 00130000
*                                                                     * 00140000
*      STATUS = Version 11                                            * 00150000
*                                                                     * 00160000
*   FUNCTION     = THIS SAMPLE EXIT DETERMINES VALUES FOR THE DB2     * 00170000
*                  AUTHORIZATION IDENTIFIERS IN A RACF ENVIRONMENT.   * 00180000
*                  THE EXIT CAN ALSO BE USED TO OBTAIN THE PRIMARY    * 00190000
*                  AUTHORIZATION ID FOR ENVIRONMENTS WITH NO SECURITY * 00200000
*                  SYSTEM INSTALLED AND ACTIVE, AS IT INCLUDES THE    * 00210000
*                  LOGIC OF THE DEFAULT DSN3@ATH EXIT.                * 00220000
*                                                                     * 00230000
*                  NOTE: THIS SAMPLE EXIT, AS PROVIDED, DOES NO RACF  * 00240000
*                        CALLS. IT RELIES ON AUTHORIZATION IDENTIFIER * 00250000
*                        FIELDS IN MVS CONTROL BLOCKS.        @KYE2164* 00260000
*                                                                     * 00270000
*     INPUT      = REGISTER 1 AT ENTRY POINTS TO A PARAMETER LIST     * 00280000
*                  CONTAINING THREE ADDRESSES.                  @dj084* 00290000
*                                                                     * 00300000
*                  PARAMETER ONE:                                     * 00310000
*                    ADDRESS OF THE EXIT PARAMETER LIST (EXPL).       * 00320000
*                    THE EXPL IS LOCATED IN KEY 7 PRIVATE STORAGE,    * 00330000
*                    ABOVE THE LINE.                                  * 00340000
*                                                                     * 00350000
*                  PARAMETER TWO:                                     * 00360000
*                    ADDRESS OF THE AUTHORIZATION ID LIST (AIDL).     * 00370000
*                    THE AIDL IS LOCATED IN KEY 7 PRIVATE STORAGE,    * 00380000
*                    ABOVE THE LINE.                                  * 00390000
*                                                                     * 00400000
*                  PARAMETER THREE:                                   * 00410000
*                    ADDRESS OF THE SESSION VARIABLE STRUCTURE (SVS). * 00420000
*                    THE SVS IS LOCATED IN KEY 7 COMMON STORAGE,      * 00430000
*                    ABOVE THE LINE.                            @dj084* 00440000
*                                                                     * 00450000
*                    THE PRIMARY AUTHORIZATION ID FIELD IN THE AIDL   * 00460000
*                    (AIDLPRIM) HAS BEEN SET TO THE VALUE IN ASXBUSER.* 00470000
*                                                                     * 00480000
*     OUTPUT     = THE AIDL IS UPDATED WITH ONE OR MORE AUTHORIZATION * 00490000
*                  IDENTIFIERS TO BE ASSOCIATED WITH THE USER'S DB2   * 00500000
*                  CONNECTION.                                        * 00510000
*                                                                     * 00520000
*                  PRIMARY AUTHORIZATION ID:                          * 00530000
*                    IF NOT NULL AT ENTRY AND CHANGE @CHAR7 NOT MADE, * 00540000
*                      ITS VALUE IS NOT CHANGED.              @KYD0271* 00550000
*                    IF NOT NULL AT ENTRY AND CHANGE @CHAR7 IS MADE,  * 00560000
*                      ITS EIGHTH CHARACTER WILL BE BLANK.    @KYD0271* 00570000
*                    IF NULL AT ENTRY AND                             * 00580000
*                      TSO FOREGROUND USER:  THE TSO LOGON ID.        * 00590000
*                      BATCH JOBS AND STC:   USER PARAMETER FROM THE  * 00600000
*                                            JOB CARD. MAY BE NULL.   * 00610000
*                                                                     * 00620000
*                  SQL AUTHORIZATION ID:                              * 00630000
*                    TSO FOREGROUND AND      TSO DATA SET PREFIX FROM * 00640000
*                       BACKGROUND:          THE TSO USER PROFILE     * 00650000
*                                            TABLE (UPT), IF IT IS    * 00660000
*                                            A VALID ID.              * 00670000
*                                                                     * 00680000
*                                            A TSO USER CAN SET THE   * 00690000
*                                            DATASET PREFIX WITH THE  * 00700000
*                                            "PROFILE PREFIX" COMMAND * 00710000
*                                            TO A VALUE WHICH IS NOT  * 00720000
*                                            THE LOGON ID AND ALSO NOT* 00730000
*                                            A RACF CONNECTED GROUP   * 00740000
*                                            NAME.  IN THIS CASE, THE * 00750000
*                                            PRIMARY ID IS USED AS THE* 00760000
*                                            CURRENT SQLID.           * 00770000
*                                                                     * 00780000
*                    ALL OTHER ENVIRONMENTS: SET TO PRIMARY AUTH ID.  * 00790000
*                                                                     * 00800000
*                  SECONDARY AUTHORIZATION IDS:                       * 00810000
*                    RACF IS NOT ACTIVE:     NO SECONDARY AUTH IDS    * 00820000
*                                            ARE DEFINED.             * 00830000
*                    RACF IS ACTIVE:                                  * 00840000
*                       LIST OF GROUPS OPTION NOT ACTIVE:             * 00850000
*                                            DEFINE SINGLE SECONDARY  * 00860000
*                                            AUTH ID AS THE CONNECTED * 00870000
*                                            GROUP NAME IN THE        * 00880000
*                                            ACEE CONTROL BLOCK.      * 00890000
*                       LIST OF GROUPS OPTION IS ACTIVE:              * 00900000
*                                            SET THE SECONDARY AUTH   * 00910000
*                                            IDS EQUAL TO THE CONNECT * 00920000
*                                            GROUP NAMES EXTRACTED    * 00930000
*                                            FROM THE ICHPCGRP BLOCK. * 00940000
*                                                                     * 00950000
*   NOTES        =                                                    * 00960000
*                                                                     * 00970000
*      TERMINOLOGY  =  THE TERMS "CONNECTION PROCESSING" AND "IDENTIFY* 00980000
*                      PROCESSING" ARE SYNONYMOUS.                    * 00990000
*                                                                     * 01000000
*      ENVIRONMENT  =  SUPERVISOR STATE, PSW KEY 7, PRIMARY ASC MODE, * 01010000
*                      AMODE(31), RMODE(ANY).                         * 01020000
*                                                                     * 01030000
*                    IN THE DISTRIBUTED DATA ENVIRONMENT:     @TU20835* 01040000
*                      EXECUTES UNDER A TCB WITHIN THE DB2    @TU20835* 01050000
*                      DISTRIBUTED DATA FACILITY (DDF)        @TU20835* 01060000
*                      ADDRESS SPACE IN NON-CROSS-MEMORY MODE @TU20835* 01070000
*                      (PRIMARY=SECONDARY=HOME) WHERE HOME IS @TU20835* 01080000
*                      THE DDF ADDRESS SPACE.                 @TU20835* 01090000
*                                                                     * 01100000
*                    IN ALL OTHER CASES:                              * 01110000
*                      EXECUTES UNDER THE TCB OF THE DB2 USER,        * 01120000
*                      NON-CROSS-MEMORY MODE (PRIMARY=SECONDARY=HOME),* 01130000
*                      WHERE HOME IS THE ADDRESS SPACE OF THE DB2     * 01140000
*                      USER REQUESTING A DB2 CONNECTION.              * 01150000
*                                                                     * 01160000
*      DEPENDENCIES =  NONE.                                          * 01170000
*                                                                     * 01180000
*      RESTRICTIONS =  THIS EXIT CANNOT BE EXECUTED UNDER DB2 V1.     * 01190000
*                                                                     * 01200000
*      REGISTER                                                       * 01210000
*      CONVENTIONS  =                                                 * 01220000
*                                                                     * 01230000
*         REGISTER R0  IS WORK REGISTER                               * 01240000
*         REGISTER R1  IS INPUT PARAMETER LIST/WORK REGISTER          * 01250000
*         REGISTER R2  IS CGRPENTD BASE REGISTER                      * 01260000
*         REGISTER R3  IS WORK REGISTER                               * 01270000
*         REGISTER R4  IS AIDLSEC BASE REGISTER                       * 01280000
*         REGISTER R5  IS CGRP BASE REGISTER                          * 01290000
*         REGISTER R6  IS ACEE BASE REGISTER                          * 01300000
*         REGISTER R7  IS RCVT BASE REGISTER                          * 01310000
*         REGISTER R8  IS ASCB BASE REGISTER                          * 01320000
*         REGISTER R9  IS EXIT PARAMETER LIST (EXPL) BASE REGISTER    * 01330000
*         REGISTER R10 IS AUTHORIZATION ID LIST (AIDL) BASE REGISTER  * 01340000
*         REGISTER R11 IS ADDRESS OF THE REENTRANT WORKING STORAGE    * 01350000
*         REGISTER R12 IS MODULE BASE REGISTER                        * 01360000
*         REGISTER R13 IS ADDRESS OF REGISTER SAVE AREA               * 01370000
*         REGISTER R14 IS RETURN ADDRESS/WORK REGISTER                * 01380000
*         REGISTER R15 IS WORK REGISTER/RETURN CODE                   * 01390000
*                                                                     * 01400000
*   MODULE TYPE  = PROCEDURE                                          * 01410000
*                                                                     * 01420000
*      PROCESSOR  = ASSEMBLER H IS REQUIRED                           * 01430000
*                                                                     * 01440000
*      ATTRIBUTES = REENTRANT, AMODE(31)                              * 01450000
*                                                                     * 01460000
*   ENTRY POINT   = DSN3@ATH                                          * 01470000
*                                                                     * 01480000
*      NOTE       = THE CSECT AND ENTRY POINT NAME MUST BE DSN3@ATH.  * 01490000
*                   THE LOAD MODULE NAME MAY, BUT NEED NOT, BE        * 01500000
*                   DSN3@ATH.                                         * 01510000
*                                                                     * 01520000
*      NOTE       = THE SOURCE CODE FOR THIS MODULE IS DISTRIBUTED    * 01530000
*                   AS MEMBER NAME DSN3SATH IN DLIB DSN???.DSNSAMP,   * 01540000
*                   WHERE ??? REPRESENTS THE DB2 VERSION, RELEASE,    * 01550000
*                   AND LEVEL NUMBER, E.G. 210 REPRESENTS DB2         * 01560000
*                   VERSION 2, RELEASE 1, LEVEL 0.                    * 01570000
*                                                                     * 01580000
*      LINKAGE    = CALL DSN3@ATH(EXPL,AIDL,SVS)                @dj084* 01590000
*                                                                     * 01600000
*                                                                     * 01610000
*   EXIT-NORMAL  =  EXPLARC = 0:  SUCCESSFUL COMPLETION.              * 01620000
*                                                                     * 01630000
*   EXIT-ERROR   =  NONE.                                             * 01640000
*                                                                     * 01650000
*   ABEND-CODES  =  NONE.                                             * 01660000
*                                                                     * 01670000
*   ERROR MESSAGES = NONE.                                            * 01680000
*                                                                     * 01690000
*   EXTERNAL                                                          * 01700000
*   REFERENCES,  =  SEE EXECUTABLE MACROS BELOW.                      * 01710000
*     ROUTINES,                                                       * 01720000
*     SERVICES                                                        * 01730000
*                                                                     * 01740000
*                                                                     * 01750000
*   DATA-AREAS   =  DB2, MVS, TSO.  SEE LIST BELOW.                   * 01760000
*                                                                     * 01770000
*   CONTROL-BLOCKS =                                                  * 01780000
*                                                                     * 01790000
*  PRODUCT    BLOCK NAME    MAPPING MACRO    FUNCTION                 * 01800000
*    MVS         CVT           CVT           COMMUNICATIONS TABLE     * 01810000
*    DB2         AIDL          DSNDAIDL      AUTHORIZATION ID LIST    * 01820000
*    DB2         EXPL          DSNDEXPL      EXIT PARAMETER LIST      * 01830000
*    DB2         SVS           DSNDSVS       SESSION VARIABLE STRUCT  * 01840000
*    DB2         SVA           DSNDSVA       SESSION VARIABLE ARRAY   * 01850000
*    DB2         NONE          DSNTIACN      CONSTANT DECLARATIONS    * 01860000
*    MVS         CGRP          ICHPCGRP      CONNECTED GROUP NAMES    * 01870000
*    MVS         RCVT          ICHPRCVT      RACF CVT                 * 01880000
*    MVS         CSCB          IEECHAIN      COMMAND SCHEDULER CNTRL  * 01890000
*    MVS         JCT           IEFAJCTB      JES CONTROL TABLE        * 01900000
*    MVS         JSCB          IEZJSCB       JOB STEP CONTROL BLOCK   * 01910000
*    MVS         ACEE          IHAACEE       ACCESSOR ENVIRONMENT     * 01920000
*                                                ELEMENT              * 01930000
*    MVS         ASCB          IHAASCB       ADDRESS SPACE CONTROL    * 01940000
*                                                BLOCK                * 01950000
*    MVS         ASXB          IHAASXB       ADDRESS SPACE EXTENSION  * 01960000
*                                                BLOCK                * 01970000
*    MVS         PSA           IHAPSA        PREFIXED STORAGE AREA    * 01980000
*    TSO/E       PSCB          IKJPSCB       PROTECTED STEP CNTRL BLK * 01990000
*    MVS         TCB           IKJTCB        TASK CONTROL BLOCK       * 02000000
*    TSO/E       UPT           IKJUPT        USER PROFILE TABLE       * 02010000
*                                                                     * 02020000
*                                                                     * 02030000
*   EXECUTABLE MACROS =                                               * 02040000
*                                                                     * 02050000
*    FREEMAIN - FREE VIRTUAL STORAGE                                  * 02060000
*    GETMAIN  - OBTAIN VIRTUAL STORAGE                                * 02070000
*    MODESET  - CHANGE PSW KEY                                        * 02080000
*    RETURN   - RETURN TO DB2 CONNECTION MANAGER                      * 02090000
*    SAVE     - SAVE DB2 CONNECTION MANAGER'S REGISTERS               * 02100000
*                                                                     * 02110000
*   CHANGE                                                            * 02120000
*   ACTIVITY     = THIS MODULE IS NEW FOR DB2, VERSION 2, RELEASE 1.  * 02130000
*                                                                     * 02140000
*                  KCT0355: NOTE THAT ASSEMBLER H IS REQUIRED.        * 02150000
*                                                                     * 02160000
*                  KZF1110: CHANGE TO NOT RETRIEVE RACF GROUP NAMES   * 02170000
*                           IN REVOKE STATUS.                 @PL32366* 02180000
*                                                                     * 02190000
*                  TU20835: THE EXIT MAY NOW BE INVOKED TO PERFORM IN * 02200000
*                           A DISTRIBUTED DATA ENVIRONMENT IN THE     * 02210000
*                           DB2 DISTRIBUTED DATA FACILITY (DDF)       * 02220000
*                           ADDRESS SPACE.  THESE INVOCATIONS MAY BE  * 02230000
*                           RECOGNIZED BY CHECKING "EXPLTYPE" AGAINST * 02240000
*                           THE CONSTANT IN FIELD "DISTTYPE" (DEFINED * 02250000
*                           IN THE PROGRAM).                  @TU20835* 02260000
*                                                                     * 02270000
*                  KYL0108: USE THE PASSED ACEE ADDRESS (AVAILABLE    * 02280000
*                           IN THE DDF ADDRESS SPACE).        @KYL0108* 02290000
*                                                                     * 02300000
*                  KYF0956: SET SQL AUTH-ID TO THE TSO PROFILE PREFIX * 02310000
*                           WHEN RACF GROUP OPTION IS INACTIVE.       * 02320000
*                                                             @PL52994* 02330000
*                                                                     * 02340000
*                  TU25003: ADD DROP STATEMENTS.              @TU25003* 02350000
*                                                                     * 02360000
*                  KYD0271: ALLOW EASY FALLBACK TO SEVEN CHARACTER    * 02370000
*                           PRIMARY AUTHID. TO FALLBACK, USER MUST    * 02380000
*                           REMOVE COMMENT DESIGNATION IN ASSEMBLER   * 02390000
*                           STATEMENT FOR CHANGE @CHAR7.      @KYD0271* 02400000
*                                                                     * 02410000
*                  KEB0026: TREAT PLUS SIGN IN JCTUSER AS NULL.       * 02420000
*                                                             @KEB0026* 02430000
*                                                                     * 02440000
*                  D28627 : ADD SUPPORT FOR TASK LEVEL ACEE DURING    * 02450000
*                           CONNECTION PROCESSING FOR RUNNING A       * 02460000
*                           UTILITY FROM A STORED PROCEDURE.          * 02470000
*                                                                     * 02480000
*                  dj084:   Support Session Variable Array      @dj084* 02490000
*                                                                     * 02500000
*                  PK07913: CORRECT BASE REGISTER FOR SVA     @PK07913* 02510000
*                  DM1465:  UNCOMMENT UTILITY TASK LEVEL AUTH  @DM1465* 02520000
*                  PI57130: Update Copyright.                         * 02525000
*********************************************************************** 02530000
         EJECT                                                          02540000
*****PSEUDOCODE******************************************************** 02550000
*                                                                     * 02560000
* DSN3@ATH PROCEDURE (EXPL,AIDL,SVS).                           @dj084* 02570000
*                                                                     * 02580000
* IF THE SIZE OF THE WORK AREA PROVIDED BY DB2 IS >= NEEDED WORK SIZE * 02590000
*   THEN ESTABLISH THE AREA AS WORKING STORAGE.                       * 02600000
* ELSE                                                                * 02610000
*   GETMAIN A WORK AREA - SUBPOOL 229, BELOW THE LINE.                * 02620000
*                                                                     * 02630000
* INITIALIZE PROGRAM VARIABLES.                                       * 02640000
*                                                                     * 02650000
**********SECTION 1:  DETERMINE THE PRIMARY AUTHORIZATION ID*********** 02660000
*                                                                     * 02670000
**** THE CODE IN THIS SECTION IS AN ASSEMBLER LANGUAGE VERSION OF  **** 02680000
**** THE DEFAULT IDENTIFY AUTHORIZATION EXIT.  IT IS EXECUTED ONLY **** 02690000
**** IF THE FIELD ASXBUSER IS NULL UPON RETURN FROM THE RACROUTE   **** 02700000
**** SERVICE.  FOR EXAMPLE, IT DETERMINES THE PRIMARY AUTH ID FOR  **** 02710000
**** ENVIRONMENTS WITH NO SECURITY SYSTEM INSTALLED AND ACTIVE.    **** 02720000
*                                                                     * 02730000
* IF THE INPUT PRIMARY AUTHORIZATION ID IS NULL OR BLANKS, THEN       * 02740000
*   DO.                                                               * 02750000
*   . IF THIS ADDRESS SPACE IS A TSO FOREGROUND USER, THEN            * 02760000
*   .   SET PRIMARY AUTHORIZATION ID EQUAL TO THE LOGON ID.           * 02770000
*   . ELSE                                                            * 02780000
*   .   SET PRIMARY AUTHORIZATION ID EQUAL TO JCTUSER.                * 02790000
*   END.                                                              * 02800000
*                                                                     * 02810000
* IF THE PRIMARY AUTHORIZATION ID EXISTS (NOT NULL OR BLANKS), THEN   * 02820000
*   DO.                                                               * 02830000
*   . IF CHANGE @CHAR7 IS MADE, THEN                          @KYD0271* 02840000
*   .   MAKE THE EIGHTH CHARACTER OF PRIMARY AUTHID BLANK     @KYD0271* 02850000
*****SECTION 2:  DETERMINE THE LIST OF SECONDARY AUTHORIZATION IDS***** 02860000
*   .                                                                 * 02870000
*   . IF RACF IS ACTIVE, THEN                                         * 02880000
*   .   DO.                                                           * 02890000
*   .   . FIND THE ACEE TO BE USED.                           @KYL0108* 02900000
*   .   . IF THE LIST OF GROUPS OPTION IS ACTIVATED, THEN             * 02910000
*   .   .   DO.                                                       * 02920000
*   .   .   . RETRIEVE THE LIST OF CONNECTED GROUP NAMES              * 02930000
*   .   .   .    FROM THE ACEE AND CGRP.                              * 02940000
*   .   .   . COPY THE GROUP NAMES INTO THE AIDL                      * 02950000
*   .   .   .    SECONDARY AUTH ID AREA                               * 02960000
*   .   .   END  LIST OF GROUPS IS ACTIVE.                            * 02970000
*   .   .                                                             * 02980000
*   .   . ELSE                         (LIST OF GROUPS IS NOT ACTIVE) * 02990000
*   .   .   DO.                                                       * 03000000
*   .   .   . IF CONNECTED GROUP NAME LENGTH IS NOT ZERO THEN           03010000
*   .   .   .   SET SECONDARY AUTH ID = ACEEGRP (CONNECTED GROUP NAME)* 03020000
*   .   .   . ELSE                         (NO VALID ACEE)            * 03030000
*   .   .   .   LEAVE SECONDARY AUTH ID LIST NULL                     * 03040000
*   .   .   END                        (LIST OF GROUPS IS NOT ACTIVE) * 03050000
*   .   .                                                             * 03060000
*   .   END                               (RACF IS ACTIVE)            * 03070000
*************SECTION 3: DETERMINE THE SQL AUTHORIZATION ID************* 03080000
*   .                                                                 * 03090000
*   . INITIALIZE SQL AUTHORIZATION ID = PRIMARY AUTHORIZATION ID.     * 03100000
*   . IF THE CONNECTION REQUEST IS FROM AN ADDRESS SPACE CONTROLLED   * 03110000
*   .   BY THE TSO TMP, THEN                                          * 03120000
*   .   DO.                                                           * 03130000
*   .   . IF THE TSO USER PROFILE TABLE IS NOT FOUND                  * 03140000
*   .   .    (TMP'S TCB -> JSCB -> PSCB -> UPT = 0) THEN              * 03150000
*   .   .   LEAVE.                  (PRIMARY ID IS THE CURRENT SQLID) * 03160000
*   .   . IF THE TSO DATASET NAME PREFIX DOES NOT EXIST THEN          * 03170000
*   .   .   LEAVE.                  (PRIMARY ID IS THE CURRENT SQLID) * 03180000
*   .   . IF THE TSO DATASET NAME PREFIX DOES NOT MATCH ONE OF THE    * 03190000
*   .   .   SECONDARY AUTHORIZATION IDS THEN                          * 03200000
*   .   .   LEAVE.                  (PRIMARY ID IS THE CURRENT SQLID) * 03210000
*   .   . SET SQL AUTHORIZATION ID EQUAL TSO DATA SET NAME PREFIX.    * 03220000
*   .   .    (SEE MODULE SPECIFICATIONS FOR NOTES ON TSO PREFIX.)     * 03230000
*   .   END.                                                          * 03240000
*   .                                                                 * 03250000
*   END                           (PRIMARY AUTHORIZATION ID NOT NULL) * 03260000
*                                                                     * 03270000
*****SECTION 4:  SET ENTRIES IN THE SESSION VARIABLE ARRAY************* 03280000
*                                                                     * 03290000
* GET ADDRESSABILITY TO THE SVA                                 @DJ084* 03300000
*   SET A USER DEFINED SESSION VARIABLE                         @DJ084* 03310000
*   UPDATE THE VARIABLE COUNT IN THE SVS                        @DJ084* 03320000
*                                                                     * 03330000
* IF A GETMAIN WAS ISSUED FOR THE WORK AREA, THEN                     * 03340000
*   FREEMAIN THE STORAGE.                                             * 03350000
*                                                                     * 03360000
* RETURN TO DB2 CONNECTION MANAGER.                                   * 03370000
* END DSN3@ATH.                                                       * 03380000
*                                                                     * 03390000
****-END-OF-SPECIFICATIONS-******************************************** 03400000
         EJECT                                                          03410000
         MACRO                                                          03420000
         MODDID                                                         03430000
.*                                                                      03440000
.*   DESCRIPTIVE-NAME = DIAGNOSTIC IDENTIFIER GENERATOR                 03450000
.*                                                                      03460000
         LCLC  &XLABA,&XLABD                                            03470000
&XLABD   SETC  '&SYSPARM'      DIAGNOSTIC LEVEL IF PROVIDED             03480000
         AIF   (K'&XLABD GT 0).SYSPOK                                   03490000
&XLABD   SETC  '&SYSTIME'      DEFAULT=SYSTIME                          03500000
.SYSPOK  ANOP                                                           03510000
         B     DSN&SYSNDX             BRANCH AROUND CONSTANT            03520000
         DC    CL8'&SYSECT',CL8'&SYSDATE',CL8'&XLABD' DIAGNOSTIC ID     03530000
&XLABA   SETC  'DSN&SYSNDX'                                             03540000
&XLABA   DS    0H                                                       03550000
         MEND                                                           03560000
         EJECT                                                          03570000
*********************************************************************** 03580000
* ENTRY AND SETUP                                                     * 03590000
*********************************************************************** 03600000
         SPACE                                                          03610000
DSN3@ATH CSECT ,                                                        03620049
DSN3@ATH AMODE 31                  <IDPR>                               03620100
DSN3@ATH RMODE ANY                 <IDPR>                               03620200
         SAVE  (14,12)             SAVE REGISTERS                       03630000
         LR    R12,R15             ESTABLISH ADDRESSABILITY             03640000
         USING DSN3@ATH,R12        USING THE ADDRESS OF THE CSECT       03650055
         MODDID                    MODULE DIAGNOSTIC IDENTIFIER         03650156
         L     R9,ZERO(,R1)        GET ADDRESS OF EXIT PARAMETER LIST   03670000
         L     R10,FOUR(,R1)       GET ADDRESS OF AUTHORIZATION ID LIST 03680000
*        REMOVE THE COMMENT ON THE FOLLOWING STATEMENT TO      @PK07913 03690000
*        IMPLEMENT THE SESSION VARIABLE CODE IN SECTION 4      @PK07913 03700000
         L     R8,EIGHT(,R1)       GET ADDRESS OF SESSION VAR STR@dj084 03710056
         USING EXPL,R9             ADDRESSABILITY TO PARM LIST MAPPING  03720000
         USING AIDL,R10            ADDRESSABILITY TO AUTH ID MAPPING    03730000
*        REMOVE THE COMMENT ON THE FOLLOWING STATEMENT TO      @PK07913 03740000
*        IMPLEMENT THE SESSION VARIABLE CODE IN SECTION 4      @PK07913 03750000
         USING SVS,R8              ADDRESSABILITY TO SVS         @dj084 03760056
         SPACE                                                          03770000
*        IF THE LENGTH OF THE PROVIDED WORK AREA IS TOO SMALL,          03780000
*        GETMAIN THE VIRTUAL STORAGE FOR THE MODULE WORK AREA.          03790000
         SPACE                                                          03800000
         L     R11,EXPLWA          GET ADDRESS OF PROVIDED WORK AREA    03810000
         LA    R2,ONE              GETMAIN INDICATOR                    03820000
         LA    R0,WORKSIZE         GET LENGTH OF NEEDED WORK AREA       03830000
         C     R0,EXPLWL           IS PROVIDED WORKAREA LARGE ENOUGH    03840000
         BNH   SATH001             SKIP GETMAIN IF YES                  03850000
         GETMAIN RU,LV=(0),SP=229,LOC=BELOW  ELSE GET MORE STORAGE      03860000
         LR    R11,R1              COPY ADDRESS OF GOTTEN AREA          03870000
         LCR   R2,R2               FLAG GETMAIN WAS DONE                03880000
SATH001  DS    0H                                                       03890000
         USING WORKAREA,R11        ESTABLISH DATA AREA ADDRESSABILITY   03900000
         ST    R2,FREMFLAG         SAVE FREEMAIN INDICATOR              03910000
         XC    SAVEAREA(72),SAVEAREA CLEAR REGISTER SAVE AREA           03920000
         LA    R15,SAVEAREA        GET ADDRESS OF CSECT'S SAVE AREA     03930000
         ST    R13,FOUR(,R15)      CHAIN THE SAVE AREA BACK POINTER     03940000
         ST    R15,EIGHT(,R13)     CHAIN SAVEAREA FORWARD               03950000
         LR    R13,R15             ADDRESS OF CSECT'S SAVE AREA         03960000
*        REMOVE THE COMMENT ON THE FOLLOWING STATEMENT TO      @PK07913 03970000
*        IMPLEMENT THE SESSION VARIABLE CODE IN SECTION 4      @PK07913 03980000
         ST    R8,SVSPTR           SAVE SVS POINTER             @DJ084  03990056
         SPACE                                                          04000000
         XC    EXPLARC,EXPLARC     INIT RETURN CODE TO NORMAL RETURN    04010000
         XC    SECCOUNT,SECCOUNT   CLEAR GROUP NAME COUNTER FIELD       04020000
         L     R8,PSAAOLD-PSA      GET CURRENT ASCB ADDRESS AND         04030000
         USING ASCB,R8             SET MAPPING ADDRESSABILITY           04040056
         EJECT                                                          04040187
**********SECTION 1:  DETERMINE THE PRIMARY AUTHORIZATION ID  ********* 04060000
*                                                                     * 04070000
*   IF THE INPUT AUTHID IS NULL OR BLANKS, CHANGE IT TO THE AUTHID    * 04080000
*   IN EITHER THE JCT OR THE FIELD POINTED TO BY ASCBJBNS.            * 04090000
*                                                                     * 04100000
*   THE CODE IN THIS SECTION IS AN ASSEMBLER LANGUAGE VERSION OF      * 04110000
*   THE DEFAULT IDENTIFY AUTHORIZATION EXIT.  IT IS EXECUTED ONLY     * 04120000
*   IF THE FIELD ASXBUSER IS NULL UPON RETURN FROM THE RACROUTE       * 04130000
*   SERVICE.  FOR EXAMPLE, IT DETERMINES THE PRIMARY AUTH ID FOR      * 04140000
*   ENVIRONMENTS WITH NO SECURITY SYSTEM INSTALLED AND ACTIVE.        * 04150000
*                                                                     * 04160000
*********************************************************************** 04170000
         SPACE                                                          04180000
         MVC   WTOE(WTOL),WTO      <IDPR>                               04180100
         MVC   WMSGULL,=H'8'           FOR DEBUGGING                    04180200
*        MVC   WMSGU,=C'<1SATH1>'                                       04180300
*        WTO   TEXT=WMSGULL,MF=(E,WTOE) <IDPR>                          04180400
         CLI   AIDLPRIM,BLANK      IS THE INPUT PRIMARY AUTHID NULL     04190000
         BH    SATH020             SKIP IF A PRIMARY AUTH ID EXISTS     04200000
         L     R7,ASCBCSCB         GET CSCB ADDRESS                     04210000
         CLI   CHTRKID-CHAIN(R7),CHTSID IS IT TSO FOREGROUND ADDR SPACE 04220000
         BNE   SATH010             BRANCH IF NOT                        04230000
         L     R7,ASCBJBNS         GET ADDRESS OF LOGON ID              04240000
         MVC   AIDLPRIM,0(R7)      MAKE IT THE PRIMARY AUTH ID          04250000
         B     SATH019             TO END OF THIS ROUTINE               04260000
SATH010  DS    0H                  NOT TSO, BUT BATCH OR STC SPACE      04270000
         L     R6,PSATOLD-PSA      CURRENT TCB ADDRESS                  04280000
         L     R7,TCBJSCB-TCB(,R6) CURRENT JSCB ADDRESS                 04290000
         L     R5,JSCBJCT-IEZJSCB(,R7) CURRENT JCT ADDRESS              04300000
         LA    R5,X'10'(,R5)       ADJUST FOR CORRECT DSECT MAPPING     04310000
         CLI   JCTUSER-INJMJCT(R5),X'4E' IF JCTUSER PLUS SIGN OR LESS   04320000
         BNH   SATH019             THEN LEAVE AIDLPRIM BLANK  KEB0026   04330000
         MVC   AIDLPRIM(7),JCTUSER-INJMJCT(R5)  COPY JOB USER ID        04340000
         MVI   AIDLPRIM+7,BLANK    ASSURE BLANK PADDING                 04350000
SATH019  DS    0H                  END OF ROUTINE                       04360000
         EJECT                                                          04370000
*****SECTION 2:  DETERMINE THE LIST OF SECONDARY AUTHORIZATION IDS***** 04380000
*                                                                     * 04390000
*    THIS SECTION IS WRITTEN SPECIFICALLY FOR THE RACF ENVIRONMENT.   * 04400000
*    IT CAN/SHOULD BE REPLACED FOR OTHER SECURITY PRODUCTS.           * 04410000
*                                                                     * 04420000
*********************************************************************** 04430000
*                                                                     * 04440000
*    IF RACF IS ACTIVE AND THE LIST OF GROUPS OPTION IS ALSO ACTIVE,  * 04450000
*    USE THE CGRP AREA TO GET THE CONNECTED GROUP NAMES.              * 04460000
*    COPY THEM TO THE SECONDARY ID LIST IN THE AIDL.                  * 04470000
*                                                                     * 04480000
*********************************************************************** 04490000
         SPACE                                                          04500000
         CLI   AIDLPRIM,BLANK      IS THE INPUT PRIMARY AUTHID NULL     04510000
         BNH   SATH090             EXIT IF PRIMARY AUTH ID NULL         04520052
SATH020  DS    0H                  BRANCH TO HERE IF PRIMARY EXISTS     04520187
*****OPTIONAL CHANGE @CHAR7:  FALLBACK TO SEVEN CHAR PRIMARY AUTHID**** 04540000
*                                                                     * 04550000
*    IF YOUR INSTALLATION REQUIRES ONLY SEVEN CHARACTER PRIMARY       * 04560000
*    AUTHORIZATION IDS (POSSIBLY TRUNCATED) DUE TO DB2 PRIVILEGES     * 04570000
*    GRANTED TO TRUNCATED AUTHORIZATION IDS, THEN YOU MUST BLANK OUT  * 04580000
*    COLUMN 1 OF THE ASSEMBLER STATEMENT IMMEDIATELY FOLLOWING THIS   * 04590000
*    BLOCK COMMENT. THEN ASSEMBLE THIS PROGRAM AND LINK-EDIT IT INTO  * 04600000
*    THE APPROPRIATE DB2 LOAD LIBRARY AS EXPLAINED IN AN APPENDIX     * 04610000
*    OF "THE DB2 ADMINISTRATION GUIDE".                               * 04620000
*                                                                     * 04630000
*    OTHERWISE, YOU NEED DO NOTHING.                                  * 04640000
*                                                             @KYD0271* 04650000
*********************************************************************** 04660000
*        MVI   AIDLPRIM+7,BLANK    BLANK OUT EIGHTH CHARACTER    @CHAR7 04670000
         SPACE                                                          04680052
         L     R5,CVTPTR           ADDRESS MVS CVT                      04690000
         L     R7,CVTRAC-CVT(,R5)  RACF CVT ADDRESS                     04700000
         LTR   R7,R7               IF RACF CVT ADDRESS ZERO,            04710000
         BZ    SATH049             RACF IS NOT EVEN INSTALLED           04720000
         USING RCVT,R7             SET BASE FOR RACF CVT                04730000
         TM    RCVTSTAT,RCVTRNA    IS RACF ACTIVE                       04740000
         BO    SATH049             SKIP AROUND IF NOT                   04750000
         SPACE 1                                                        04760000
*   RACF IS ACTIVE ON THIS MVS                                          04770000
         USING ACEE,R6             ESTABLISH BASE FOR ACEE     @KYL0108 04780000
         ICM   R6,B'1111',AIDLACEE CALLER PASSED ACEE ADDRESS? @KYL0108 04790000
         BZ    SATH024             NO, USE ADDRESS SPACE ACEE  @KYL0108 04800000
         CLC   ACEEACEE,EYEACEE    IS IT REALLY AN ACEE?       @KYL0108 04810000
         BE    SATH027             YES, PROCEED NORMALLY       @KYL0108 04820000
         SPACE 1                                                        04830000
SATH024  DS    0H                  USE ADDRESS SPACE ACEE      @KYL0108 04840000
*********************************************************************** 04850000
*    THE FOLLOWING CODE SUPPORTS THE USE OF THE TASK LEVEL ACEE FOR   * 04860000
*    CONNECTION PROCESSING INSTEAD OF THE ADDRESS SPACE LEVEL ACEE.   * 04870000
*    THE CODE WILL TRY TO USE THE TCB ACEE AND THEN THE ASXB ACEE.    * 04880000
*    THIS CHANGE WILL ALLOW PROPER SECONDARY AUTHORIZATION CHECKING   * 04890000
*    WHILE RUNNING DB2 UTILITIES FROM A STORED PROCEDURE.  YOU MAY    * 04900000
*    REMOVE THIS SUPPORT BY COMMENTING THE LINES MARKED @DM1465       * 04910000
*    BETWEEN THIS POINT AND UP TO THE LINE LABELED SATH025.    @DM1465* 04920000
*********************************************************************** 04930000
         SPACE 1                                                        04940000
         CLC   EXPLTYPE,BATCH      IS CONNECTION TYPE BATCH?    @DM1465 04950000
         BNE   SATH025                                          @DM1465 04960000
         CLC   EXPLCONN,UTILITY    IS CONNECTION NAME UTILITY?  @DM1465 04970000
         BNE   SATH025                                          @DM1465 04980000
         L     R6,PSATOLD-PSA      CURRENT TCB ADDRESS          @DM1465 04990000
         L     R6,TCBSENV-TCB(,R6) GET TASK LEVEL ACEE          @DM1465 05000000
         LTR   R6,R6               TASK LEVEL ACEE AVAILABLE?   @DM1465 05010000
         BZ    SATH025             NO, GO TRY ADDRESS SPACE     @DM1465 05020000
         CLC   ACEEACEE,EYEACEE    DOES IT LOOK LIKE AN ACEE?   @DM1465 05030000
         BE    SATH027             YES, THEN USE IT             @DM1465 05040000
SATH025  DS    0H                                              @PQ51163 05050000
         L     R6,ASCBASXB         GET ADDRESS SPACE EXTENSION BLOCK    05060000
         L     R6,ASXBSENV-ASXB(,R6)  GET ACEE ADDRESS                  05070000
         LTR   R6,R6               DOES AN ACEE EXIST?  IF NOT,         05080000
         BZ    SATH049             SKIP AROUND CONNECTED GROUP NAME     05090000
         CLC   ACEEACEE,EYEACEE    DOES IT LOOK LIKE AN ACEE?           05100000
         BNE   SATH049             NO, THEN CAN'T DO GROUPS             05110000
         DROP  R8                  DROP ASCB BASE REG          @TU25003 05120000
         SPACE 1                                                        05130000
SATH027  DS    0H                  CHECK LIST OF GROUPS OPTION @KYL0108 05140000
         TM    RCVTOPTX,RCVTLGRP   IS LIST OF GROUPS CHECKING ACTIVE    05150000
         BZ    SATH040             SKIP TO SINGLE GROUP COPY IF NOT     05160000
         DROP  R7                  DROP RCVT BASE REG          @TU25003 05170000
         SPACE 1                                                        05180000
*   RACF LIST OF GROUPS OPTION IS ACTIVE                                05190000
         EJECT                                                          05200000
*********************************************************************** 05210000
*                                                                     * 05220000
*    COPY THE RACF GROUP NAMES INTO THE AIDL AS SECONDARY AUTHIDS     * 05230000
*                                                                     * 05240000
*********************************************************************** 05250000
         SPACE 1                                                        05260087
*        CREATING CLIENT ID SESSION VARIABLES <IDPR>                    05260100
         L     R7,ACEEIDID                                              05270000
         LTR   R7,R7                                                    05270100
         BZ    SATH036X                                                 05270674
         USING IDID,R7             ACCESS IDID                          05270787
         L     R4,IDIDOFF1                                              05271000
         LTR   R4,R4                                                    05271100
         BZ    SATH036X                                                 05271274
         LA    R5,0(R4,R7)                                              05271474
         USING IDIDSEC1,R5         ACCESS SECTION1                      05271587
         L     R4,IDID1OF1                                              05271600
         LTR   R4,R4                                                    05271700
         BZ    SATH036X                                                 05271874
         LA    R3,0(R4,R5)                                              05271900
         USING IDID1USR,R3         USER ID/DN                           05272500
         CLC   IDID1UDL,=H'0'                                           05272674
         BE    SATH036X                                                 05272775
*        CREATE SESSION VARIABLE CLIENT_USERID                          05272887
         L     R8,SVSPTR           RETRIEVE SVS POINTER                 05272975
         USING SVS,R8              ADDRESSABILITY TO SVS                05273075
         MVC   SVSACT,=F'1'        ONE ENTRY                            05273175
         L     R8,SVSSVA31         GET ADDRESS OF SVA                   05273275
         USING SVA,R8                                                   05273375
         MVC   SVANMLEN,=AL2(L'CUIDNAME)                                05273482
         MVC   SVANMSTR(L'CUIDNAME),CUIDNAME VAR LL, NAME               05273587
         LH    R15,IDID1UDL                                             05273682
         CH    R15,=H'255'                                              05273775
         BNH   SATH036L                                                 05273875
         LA    R15,255                                                  05273975
SATH036L STH   R15,SVAVLLEN        USERNAME LL FROM IDID1DL MAX 255     05274087
         LR    R1,R15                                                   05274182
         LA    R0,SVAVLSTR                                              05274282
         LA    R14,IDID1UDN                                             05274382
         MVCL  R0,R14              MOVE IDID1UDN VARIABLE VALUE         05274487
*        CREATE REGISTRY SESSION VARIABLE                               05274500
         L     R4,IDID1OF2                                              05274600
         LTR   R4,R4                                                    05274700
         BZ    SATH036X                                                 05275087
         LA    R3,0(R4,R5)                                              05275100
         USING IDID1REG,R3         REGISTRY                             05275300
         CLC   IDID1RL,=H'0'                                            05275400
         BE    SATH036X                                                 05275887
*        CREATE SESSION VARIABLE CURRENT CLIENT_USERID                  05275987
         L     R8,SVSPTR           RETRIEVE SVS POINTER                 05276087
         USING SVS,R8              ADDRESSABILITY TO SVS                05276187
         MVC   SVSACT,=F'2'        ONE ENTRY                            05276287
         L     R8,SVSSVA31         GET ADDRESS OF SVA                   05276387
         USING SVA,R8                                                   05276487
         LA    R8,SVANEXT                                               05276587
         MVC   SVANMLEN,=AL2(L'CREGNAME)                                05276687
         MVC   SVANMSTR(L'CREGNAME),CREGNAME VAR LL, NAME               05276787
         LH    R15,IDID1RL                                              05276887
         CH    R15,=H'255'                                              05276987
         BNH   SATH036M                                                 05277087
         LA    R15,255                                                  05277187
SATH036M STH   R15,SVAVLLEN        REGISTRY LL FROM IDID1RL MAX 255     05277200
         LR    R1,R15                                                   05277387
         LA    R0,SVAVLSTR                                              05277487
         LA    R14,IDID1RN                                              05277587
         MVCL  R0,R14              MOVE IDID1RN VARIABLE VALUE          05277687
         DROP  R8,R7,R5,R3                                              05277700
SATH036X DS    0H                  <IDPR>                               05277800
*   INITIALIZE FOR COPYING THE GROUP NAMES TO THE AIDL                  05277987
         L     R5,ACEEFCGP         CONNECT GROUP BLOCK                  05280000
         LTR   R5,R5               ENSURE THE BLOCK IS THERE            05290000
         BZ    SATH049             THE COUNT IS ZERO, SKIP IT           05300000
         USING CGRP,R5             SET BASE FOR CONNECT GROUP           05310000
         CLC   CGRPID,EYECGRP      DOES IT LOOK LIKE A CGRP BLOCK?      05320000
         BNE   SATH049             NO, GROUP NAMES NOT AVAILABLE        05330000
         SLR   R3,R3               CLEAR THE COUNTER REGISTER           05340000
         ICM   R3,B'0011',CGRPNUM  GET THE NUMBER OF CONNECT GROUPS     05350000
         ST    R3,SECCOUNT         SAVE COUNT OF GROUPS                 05360000
         BZ    SATH049             BR IF NO GROUP NAMES AVAILABLE       05370000
         LA    R2,CGRPENT          POINT TO CONNECT GROUP ENTRIES       05380000
         USING CGRPENTD,R2         SET BASE FOR CONNECT GROUP ENTRIES   05390000
         SPACE 1                                                        05400000
         LA    R4,AIDLSEC          ADDRESS OF SECONDARY IDS             05410000
         USING SGRP,R4             SET BASE FOR SECONDARY GROUPS        05420000
         L     R0,AIDLSCNT         GET NUMBER OF SLOTS FOR SECONDARIES  05430000
         MH    R0,SECLEN           TIMES THE LENGTH OF A SLOT           05440000
         AR    R0,R4               CALCULATE THE STOPPER ADDRESS FOR    05450000
         DROP  R5                  DROP CGRP BASE REG          @TU25003 05460000
*                                  MOVING SECONDARY AUTHIDS             05470000
         SPACE 1                                                        05480000
*   COPY THE GROUP NAMES TO THE AIDL                                    05490000
SATH036  DS    0H                  COUNTER SET FOR MOVING               05500000
         TM    CGRPNAME,X'BF'      SEE IF THE GROUP IS VALID            05510000
         BNM   SATH037             BR IF NULL, BLANK, OR FF             05520000
         MVC   SGRPNAME,CGRPNAME   MOVE THE GROUP NAME                  05530000
         LA    R4,SGRPNEXT         POINT TO NEXT SECONDARY AUTHID       05540000
         CR    R4,R0               HAVE WE USED ALL THE SLOTS?          05550000
         BNL   SATH049             YES, MOVING IS COMPLETED             05560000
SATH037  DS    0H                  BYPASS UPDATING SECONDARY LIST       05570000
         SPACE 1                                                        05580000
         LA    R2,L'CGRPENT(,R2)   POINT TO NEXT CONNECT GROUP          05590000
         BCT   R3,SATH036          BR UNTIL ALL GROUP NAMES EXAMINED    05600000
         B     SATH049             MOVING IS COMPLETED                  05610000
         DROP  R2                  DROP CGRPENTD BASE REG      @TU25003 05620000
         EJECT                                                          05630000
*********************************************************************** 05640000
*                                                                     * 05650000
*    IF RACF IS ACTIVE, BUT THE LIST OF GROUPS OPTION IS NOT ACTIVE,  * 05660000
*    THE CONNECTED GROUP NAME IN THE ACEE IS COPIED TO THE AIDL AS A  * 05670000
*    SINGLE SECONDARY AUTHORIZATION ID.                               * 05680000
*                                                                     * 05690000
*********************************************************************** 05700000
         SPACE 1                                                        05710000
SATH040  DS    0H                  GET CONNECTED GROUP NAME FROM ACEE   05720000
         SR    R2,R2                                                    05730000
         ICM   R2,1,ACEEGRPL       GET LENGTH OF GROUP NAME             05740000
         BZ    SATH049             SKIP COPY IF LENGTH IS ZERO          05750000
         SPACE 1                                                        05760000
         BCTR  R2,0                LESS ONE FOR THE MVC                 05770000
         EX    R2,GRPCOPY          COPY GROUP NAME AS SECONDARY AUTH ID 05780000
         SPACE 1                                                        05790000
         LA    R2,1                GET COUNT OF SEC AUTH IDS   @PL52994 05800000
         ST    R2,SECCOUNT         STORE IT FOR LATER          @PL52994 05810000
SATH049  DS    0H                  BRANCH TO HERE IF RACF NOT ACTIVE    05820000
         EJECT                                                          05830000
*************SECTION 3: DETERMINE THE SQL AUTHORIZATION ID************* 05840000
*                                                                     * 05850000
*     IF THE CURRENT ADDRESS SPACE IS A TSO TMP-CONTROLLED ADDRESS    * 05860000
*     SPACE, SET THE INITIAL VALUE OF THE SQL AUTHORIZATION ID        * 05870000
*     EQUAL TO THE TSO DATA SET PREFIX IF VALID.  OTHERWISE, SET THE  * 05880000
*     INITIAL VALUE EQUAL TO THE PRIMARY AUTH ID.                     * 05890000
*                                                                     * 05900000
*********************************************************************** 05910000
         MVC   AIDLSQL,AIDLPRIM    INIT SQL ID TO PRIMARY               05920000
         L     R7,PSATOLD-PSA      GET THE CURRENT TCB ADDRESS          05930000
         L     R6,TCBJSCB-TCB(,R7) GET JOB STEP CONTROL BLOCK           05940000
         L     R6,JSCBPSCB-IEZJSCB(,R6) GET TMP'S PROTECTED STEP BLOCK  05950000
         SPACE 1                                                        05960000
*        IF A PSCB EXISTS, THIS IS A TSO ADDRESS SPACE.                 05970000
         LTR   R6,R6               DOES THE PSCB EXIST?                 05980000
         BZ    SATH089             NO, LEAVE SQL AUTH ID EQUAL PRIMARY  05990000
         SPACE 1                                                        06000000
         MVC   CSQLID,BLANKS       DEFAULT VALUE FOR DSN PREFIX         06010000
         MODESET EXTKEY=ZERO       PSCB AND UPT IN FETCH-PROTECTED STOR 06020000
         L     R6,PSCBUPT-PSCB(,R6)  GET USER PROFILE TABLE             06030000
         LTR   R6,R6               DOES THE UPT EXIST?                  06040000
         BZ    SATH060             NO, LEAVE SQL AUTH ID EQUAL PRIMARY  06050000
         SPACE 1                                                        06060000
         SR    R2,R2               PREPARE TO MOVE THE DSN PREFIX       06070000
         ICM   R2,1,UPTPREFL-UPT(R6)  GET PREFIX LENGTH                 06080000
         BZ    SATH060             SKIP MOVE IF NULL PREFIX             06090000
         SPACE 1                                                        06100000
         BCTR  R2,0                LESS ONE FOR MVC INSTRUCTION         06110000
         EX    R2,PREFCOPY         COPY TSO DSN PREFIX TO WORK AREA     06120000
         SPACE 1                                                        06130000
SATH060  DS    0H                  BRANCH TO HERE IF NOT TSO SPACE      06140000
         MODESET EXTKEY=KEY7       RESET PSW KEY TO DB2'S KEY           06150000
         EJECT                                                          06160000
*********************************************************************** 06170000
*                                                                     * 06180000
*   SEE IF THE PREFIX IS VALID AND SET THE CURRENT SQLID IF SO        * 06190000
*                                                                     * 06200000
*********************************************************************** 06210000
         CLC   CSQLID,BLANKS       DID WE FIND A TSO DSN PREFIX?        06220000
         BE    SATH089             NO, BYPASS THE LOOP BELOW            06230000
         CLC   CSQLID,AIDLSQL      IS IT THE SAME AS WHAT WE HAVE?      06240000
         BE    SATH089             YES, WE DON'T NEED THE LOOP BELOW    06250000
         SPACE 1                                                        06260000
*   INITIALIZE TO SCAN THE SECONDARIES                                  06270000
         L     R3,SECCOUNT         GET COUNT OF GROUPS                  06280000
         LTR   R3,R3               IS THE COUNT SET?                    06290000
         BNP   SATH089             NO, DON'T SET THE PREFIX             06300000
         LA    R4,AIDLSEC          ADDRESS OF SECONDARY IDS             06310000
         SPACE 1                                                        06320000
*   VALIDATE THAT THE TSO DATASET NAME PREFIX IS A VALID AUTHID         06330000
SATH086  DS    0H                  COUNTER SET FOR MOVING               06340000
         CLI   SGRPNAME,BLANK      HAVE WE RUN OUT OF SECONDARIES?      06350000
         BNH   SATH089             YES, ABORT THE SCAN                  06360000
         CLC   SGRPNAME,CSQLID     IS THIS THE PREFIX GROUP             06370000
         BNE   SATH088             NO, DON'T SET THE PREFIX             06380000
         MVC   AIDLSQL,CSQLID      INIT SQL ID TO THE VALID VALUE       06390000
         B     SATH089             THE PREFIX IS ESTABLISHED            06400000
SATH088  DS    0H                  POINT TO THE NEXT ENTRY AND COUNT    06410000
         LA    R4,SGRPNEXT         POINT TO THE NEXT SECONDARY          06420000
         BCT   R3,SATH086          MOVE UNTIL DONE                      06430000
         DROP  R4                  DROP SGRP BASE REG          @TU25003 06440000
SATH089  DS    0H                  BRANCH TO HERE IF NOT TSO SPACE      06450000
         EJECT                                                          06460000
*****SECTION 4:  SET ENTRIES IN THE SESSION VARIABLE ARRAY************* 06470000
*                                                                     * 06480000
*   THE FOLLOWING LINES OF CODE ARE A SAMPLE USE OF THE SVS AND SVA   * 06490000
*   GET ADDRESSABILITY TO THE SESSION VARIABLE ARRAY (SVA) FROM       * 06500000
*   THE SESSION VARIABLE STRUCTURE (SVS) AND UPDATE THE ARRAY         * 06510000
*   WITH USER DETERMINED VARIABLES.                                   * 06520000
*   SESSION VARIABLE ENTRIES CONTAIN A VARCHAR(128) VARIABLE NAME     * 06530000
*   AND A VARCHAR(255) VARIABLE STRING.  SESSION VARIABLE CHARACTER   * 06540000
*   DATA SHOULD BE UNICODE CCSID 1208.                                * 06550000
*   IF YOU REMOVE COMMENTS TO COMPILE THE CODE IN THIS        @PK07913* 06560000
*   SECTION, YOU MUST ALSO REMOVE THE COMMENT FROM TWO        @PK07913* 06570000
*   STATEMENTS FOLLOWING LABEL DSN3@ATH, AND ONE STATEMENT    @PK07913* 06580000
*   FOLLOWING LABEL SATH001.  YOU SHOULD ALSO REMOVE COMMENTS @PK07913* 06590000
*   ON DECLARED VARIABLES USED BY SECTION 4, THE SVSPTR AND   @PK07913* 06600000
*   THE DECLARES FOR DSNDSVS AND DSNDSVA.  THESE COMMENTED    @PK07913* 06610000
*   STATEMENTS ARE ALL FLAGGED WITH WITH @DJ084.              @PK07913* 06620000
*                                                                     * 06630000
*********************************************************************** 06640000
*                                                                     * 06650000
*   GET ADDRESSABILITY TO THE SVA                                     * 06660000
*   SET A USER DEFINED SESSION VARIABLE                               * 06670000
*   UPDATE THE VARIABLE COUNT IN THE SVS                              * 06680000
*                                                                     * 06690000
*********************************************************************** 06700000
         SPACE                                                          06710062
*        L     R8,SVSPTR           RETRIEVE SVS POINTER          @dj084 06710175
*        USING SVS,R8              ADDRESSABILITY TO SVS         @dj084 06730075
*        L     R4,SVSSVA31         GET ADDRESS OF SVA          @PK07913 06740075
*        USING SVA,R4              ADDRESSABILITY SVA MAPPING  @PK07913 06750075
*        L     R3,LOCFIVE          GET THE LENGTH                @dj084 06760075
*        STH   R3,SVANMLEN         SET THE VAR NAME LENGTH IN SVA@dj084 06770075
*        MVC   SVANMSTR(5),LOCNAME SET THE VAR NAME IN THE SVA   @dj084 06780075
*        L     R3,LOCSEVEN         GET THE LENGTH                @dj084 06790075
*        STH   R3,SVAVLLEN         SET THE VAR STRING LENGTH SVA @dj084 06800075
*        MVC   SVAVLSTR(7),LOCSTRNG SET THE VAR STRING IN THE SVA@dj084 06810075
*        L     R3,LOCCOUNT         GET THE COUNT                 @dj084 06820075
*        ST    R3,SVSACT           SET THE SESSION VAR COUNT     @dj084 06830075
*        DROP  R4                  DROP SVA BASE REG           @PK07913 06840075
*        DROP  R8                  DROP SVS BASE REG           @PK07913 06850075
*        EJECT                                                          06860000
*********************************************************************** 06870000
*                                                                     * 06880000
*   FREEMAIN THE WORK AREA IF NECESSARY AND RETURN                    * 06890000
*                                                                     * 06900000
*********************************************************************** 06910000
         SPACE                                                          06920000
SATH090  DS    0H                                                       06930000
         L     R3,FOUR(,R13)       PRESERVE ADDRESS CALLER'S SAVE AREA  06940000
         L     R2,FREMFLAG         WAS A GETMAIN DONE FOR WORK AREA     06950000
         LTR   R2,R2                                                    06960000
         BP    SATH099             SKIP FREEMAIN IF NOT                 06970000
         LA    R0,WORKSIZE         STORAGE SIZE                         06980000
         LR    R1,R11              STORAGE ADDRESS                      06990000
         FREEMAIN RU,LV=(0),A=(1),SP=229                                07000000
         DROP  R9                  DROP EXPL BASE REG          @TU25003 07010000
SATH099  DS    0H                                                       07020000
         LR    R13,R3              REMEDY SAVE AREA ADDRESS             07030000
         RETURN (14,12),,RC=0      RETURN TO DB2 CONNECTION MANAGER     07040000
         EJECT                                                          07050000
*********************************************************************** 07060000
*                                                                     * 07070000
*   DEFINE MODULE CONSTANT DATA                                       * 07080000
*                                                                     * 07090000
*********************************************************************** 07100000
         SPACE                                                          07110000
PREFCOPY MVC   CSQLID(0),UPTPREFX-UPT(R6) COPY TSO PREFIX TO WORK AREA  07120000
GRPCOPY  MVC   AIDLSEC(0),ACEEGRPN  COPY CONNECTED GROUP NAME           07130000
SECLEN   DC    Y(SGRPNEXT-SGRP)    LENGTH OF A SECONDARY AUTHID ENTRY   07140000
BLANKS   DC    CL8' '              STRING OF 8 BLANKS                   07150000
EYEACEE  DC    C'ACEE'             IHAACEE BLOCK EYECATCHER             07160000
EYECGRP  DC    C'CGRP'             ICHPCGRP BLOCK EYECATCHER            07170000
*        REMOVE THE COMMENT ON THE FOLLOWING STATEMENTS TO     @PK07913 07180000
*        IMPLEMENT THE SESSION VARIABLE CODE IN SECTION 4      @PK07913 07190000
CUIDNAME DC    XL13'434c49454e545f555345524944' CLIENT_USERID  <IDPR>   07200000
CREGNAME DC    XL15'434c49454e545f5245474953545259' CLIENT_REGISTRY     07200100
WTO      WTO   TEXT=(),ROUTCDE=(11),MF=L                                07240187
WTOL     EQU   *-WTO              <IDPR>                                07240200
         DS    0F                                                       07240656
         EJECT                                                          07250000
*********************************************************************** 07260000
*                                                                     * 07270000
* REENTRANT WORKING STORAGE AREA                                      * 07280000
*                                                                     * 07290000
*********************************************************************** 07300000
         SPACE                                                          07310000
WORKAREA DSECT                                                          07320000
SAVEAREA DS    18F                 REGISTER SAVE AREA - NOT USED        07330000
FREMFLAG DS    F                   DO FREEMAIN IF NEGATIVE              07340000
SECCOUNT DS    F                   COUNT OF SECONDARY IDS               07350000
CSQLID   DS    CL8                 TEMPORARY AREA FOR CURRENT SQLID     07360000
*        REMOVE THE COMMENT ON THE FOLLOWING STATEMENT TO      @PK07913 07370000
*        IMPLEMENT THE SESSION VARIABLE CODE IN SECTION 4      @PK07913 07380000
SVSPTR   DS    F                   SAVE POINTER TO SVS           @DJ084 07390056
         DS    0F                  <IDPR>                               07390100
WTOE     DS    CL(WTOL)                                                 07390262
WMSGULL  DS    H                                                        07390449
WMSGU    DS    CL(8)                                                    07390575
         DS    0F                  <IDPR>                               07390700
         SPACE                                                          07400000
WORKSIZE EQU   *-WORKAREA          WORKING STORAGE SIZE CALCULATION     07410000
         SPACE                                                          07420000
SGRP     DSECT                                                          07430000
SGRPNAME DS    CL8                 MOVE SECONDARY GROUPS HERE           07440000
SGRPNEXT EQU   *                   NEXT SECONDARY NAME STARTS HERE      07450000
         EJECT                                                          07460000
*********************************************************************** 07470000
*                                                                     * 07480000
*  DB2 CONTROL BLOCK MAPPING MACROS                                   * 07490000
*                                                                     * 07500000
*********************************************************************** 07510000
         SPACE                                                          07520000
         DSNDEXPL                                                       07530000
         SPACE                                                          07540000
DSN3@ATH CSECT                                                          07550000
*********************************************************************** 07560000
*                                                                     * 07570000
*  THESE CONSTANTS DEFINE THE VALUES OF CONNECTION TYPE WHICH IS      * 07580000
*  AVAILABLE IN FIELD EXPLTYPE FOR USE BY AN AUTHORIZATION EXIT.      * 07590000
*                                                                     * 07600000
*********************************************************************** 07610000
IMSTYPE  DC    CL8'MASS'      CONSTANT FOR IMS CONNECTION               07620000
CICSTYPE DC    CL8'SASS'      CONSTANT FOR CICS CONNECTION              07630000
BTCHTYPE DC    CL8'BATCH'     CONSTANT FOR TSO, BATCH, STARTED TASK     07640000
DISTTYPE DC    CL8'DIST'      CONSTANT FOR DISTRIBUTED DATA             07650000
*                                CONNECTION                    @TU20835 07660000
BATCH    DC    CL8'BATCH   '                                   @PQ51163 07670000
*********************************************************************** 07680000
*                                                                     * 07690000
*  THESE CONSTANTS DEFINE THE VALUES OF CONNECTION NAME WHICH IS      * 07700000
*  AVAILABLE IN FIELD EXPLCONN FOR USE BY AN AUTHORIZATION EXIT.      * 07710000
*                                                             @PQ51163* 07720000
*********************************************************************** 07730000
UTILITY DC     CL8'UTILITY '                                   @PQ51163 07740000
                                                                        07750000
         EJECT                                                          07760000
         DSNDAIDL                                                       07770000
         EJECT                                                          07780000
*        REMOVE THE COMMENT ON THE FOLLOWING STATEMENTS TO     @PK07913 07790000
*        IMPLEMENT THE SESSION VARIABLE CODE IN SECTION 4      @PK07913 07800000
         DSNDSVS                                                        07810056
         EJECT                                                          07820056
         DSNDSVA                                                        07830056
         EJECT                                                          07840056
         DSNTIACN ,                CONSTANT DECLARATIONS                07850000
         EJECT                                                          07860000
*********************************************************************** 07870000
*                                                                     * 07880000
*  MVS/XA AND TSO/E CONTROL BLOCK MAPPING MACROS                      * 07890000
*                                                                     * 07900000
*********************************************************************** 07910000
         SPACE                                                          07920000
         PUSH  PRINT                                                    07930000
         PRINT OFF                                                      07940000
         CVT   DSECT=YES                                                07950000
         ICHPRCVT                                                       07960000
         IHAACEE                                                        07970069
         IRRPIDID                                                       07970169
         ICHPCGRP                                                       07980000
         IHAPSA                                                         07990000
         IKJTCB                                                         08000000
         IKJPSCB                                                        08010000
         IKJUPT                                                         08020000
IEFAJCTB DSECT                                                          08030000
         IEFAJCTB                                                       08040000
         IEZJSCB                                                        08050000
         IHAASCB                                                        08060000
         IHAASXB                                                        08070000
IEECHAIN DSECT                                                          08080000
         IEECHAIN                                                       08090000
         POP   PRINT                                                    08100000
DSN3@ATH CSECT ,                                                        08110000
         END   DSN3@ATH            END OF MODULE                     */ 08120000