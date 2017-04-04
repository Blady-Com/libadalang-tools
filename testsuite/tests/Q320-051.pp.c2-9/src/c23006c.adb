
WITH C23006C_PROC, C23006CPROC, C23006C_FUNC, C23006CFUNC;
WITH REPORT; USE REPORT;
PROCEDURE C23006C IS
     X1, X2 : INTEGER;
BEGIN
     TEST ("C23006C", "CHECK UNDERSCORES ARE SIGNIFICANT " &
                      "FOR LIBRARY SUBPROGRAM");

     C23006C_PROC (X1);
     C23006CPROC (X2);
     IF X1 + IDENT_INT(1) /= X2 THEN
          FAILED ("INCORRECT PROCEDURE IDENTIFICATION");
     END IF;

     IF C23006C_FUNC + IDENT_INT(1) /= C23006CFUNC THEN
          FAILED ("INCORRECT FUNCTION IDENTIFICATION");
     END IF;

     RESULT;
END C23006C;