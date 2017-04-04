-- C45613A.ADA

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
-- CHECK THAT CONSTRAINT_ERROR IS RAISED BY "**" FOR INTEGERS WHEN THE RESULT
-- EXCEEDS THE RANGE OF THE BASE TYPE.

-- *** NOTE: This test has been modified since ACVC version 1.11 to -- 9X ***
-- remove incompatibilities associated with the transition -- 9X *** to Ada 9X.
-- -- 9X *** -- 9X

-- H. TILTON 10/06/86
--      MRM 03/30/93 REMOVED NUMERIC_ERROR FOR 9X COMPATIBILITY

with Report; use Report;
procedure C45613a is

begin
   Test
     ("C45613A",
      "CHECK THAT CONSTRAINT_ERROR " &
      "IS RAISED BY ""**"" FOR INTEGERS WHEN THE " &
      "RESULT EXCEEDS THE RANGE OF THE BASE TYPE");

   declare
      Int : Integer;
   begin
      Int := Ident_Int (Integer'Last**Ident_Int (2));
      Failed ("NO EXCEPTION FOR SECOND POWER OF INTEGER'LAST");

   exception
      when Constraint_Error =>
         null;
      when others =>
         Failed
           ("WRONG EXCEPTION RAISED FOR " &
            "SECOND POWER OF " &
            "INTEGER'LAST");
   end;

   declare
      Int : Integer;
   begin
      Int := Ident_Int (Integer'First**Ident_Int (3));
      Failed ("NO EXCEPTION FOR THIRD POWER OF INTEGER'FIRST");

   exception
      when Constraint_Error =>
         null;
      when others =>
         Failed
           ("WRONG EXCEPTION RAISED FOR " &
            "THIRD POWER OF " &
            "INTEGER'FIRST");

   end;

   Result;

end C45613a;
