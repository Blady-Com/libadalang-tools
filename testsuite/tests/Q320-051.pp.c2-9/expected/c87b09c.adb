-- C87B09C.ADA

--                             Grant of Unlimited Rights
--
--     Under contracts F33600-87-D-0337, F33600-84-D-0280, MDA903-79-C-0687,
--     F08630-91-C-0015, and DCA100-97-D-0025, the U.S. Government obtained
--     unlimited rights in the software and documentation contained herein.
--     Unlimited rights are defined in DFAR 252.227-7013(a)(19).  By making
--     this public release, the Government intends to confer upon all
--     recipients unlimited rights  equal to those held by the Government.
--     These rights include rights to use, duplicate, release or disclose the
--     released technical data and computer software in whole or in part, in
--     any manner and for any purpose whatsoever, and to have or permit others
--     to do so.
--
--                                    DISCLAIMER
--
--     ALL MATERIALS OR INFORMATION HEREIN RELEASED, MADE AVAILABLE OR
--     DISCLOSED ARE AS IS.  THE GOVERNMENT MAKES NO EXPRESS OR IMPLIED
--     WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING THE CONDITIONS OF THE
--     SOFTWARE, DOCUMENTATION OR OTHER INFORMATION RELEASED, MADE AVAILABLE
--     OR DISCLOSED, OR THE OWNERSHIP, MERCHANTABILITY, OR FITNESS FOR A
--     PARTICULAR PURPOSE OF SAID MATERIAL.
--*
-- CHECK THAT OVERLOADING RESOLUTION USES THE RULE THAT:
--
-- IN A FLOATING POINT TYPE DEFINITION, THE DIGITS EXPRESSION MUST BE OF
-- SOME INTEGRAL TYPE. SIMILARLY, THE DELTA EXPRESSION IN A FIXED POINT
-- TYPE DEFINITION MUST BE OF SOME REAL TYPE.

-- TRH  30 JUNE 82

with Report; use Report;

procedure C87b09c is

   function "+" (X : Integer) return Float is
   begin
      Failed ("DIGITS EXPRESSION MUST BE OF AN INTEGRAL TYPE");
      return 2.0;
   end "+";

   function "+" (X : Float) return Integer is
   begin
      Failed ("DELTA EXPRESSION MUST BE OF A REAL TYPE");
      return 2;
   end "+";

begin
   Test
     ("C87B09C",
      "OVERLOADED DIGITS/DELTA EXPRESSIONS IN " & "REAL TYPE DEFINITIONS");

   declare
      type Exact is digits "+" (4);
      type Centi is delta "+" (0.01) range -2.0 .. 2.0;
      type Close is digits "+" (2) range -1.0 .. 1.0;
      type Deci is delta "+" (0.1) range -1.0 .. 1.0;

   begin
      null;
   end;

   Result;
end C87b09c;