-- CA2008A0M.ADA

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
-- CHECK THAT FOR AN OVERLOADED SUBPROGRAM, ONE OF THE
--   SUBPROGRAM BODIES CAN BE SPECIFIED WITH A BODY_STUB AND
--   COMPILED SEPARATELY.

-- SEPARATE FILES ARE:
--   CA2008A0M THE MAIN PROCEDURE.
--   CA2008A1  A SUBUNIT PROCEDURE BODY.
--   CA2008A2  A SUBUNIT FUNCTION BODY.

-- WKB 6/26/81
-- SPS 11/2/82

with Report; use Report;
procedure Ca2008a0m is

   I : Integer := 0;
   B : Boolean := True;

   procedure Ca2008a1 (I : in out Integer) is
   begin
      I := Ident_Int (1);
   end Ca2008a1;

   procedure Ca2008a1 (B : in out Boolean) is separate;

   function Ca2008a2 return Integer is separate;

   function Ca2008a2 return Boolean is
   begin
      return Ident_Bool (False);
   end Ca2008a2;

begin
   Test
     ("CA2008A",
      "CHECK THAT AN OVERLOADED SUBPROGRAM " &
      "CAN HAVE ONE OF ITS BODIES COMPILED SEPARATELY");

   Ca2008a1 (I);
   if I /= 1 then
      Failed ("OVERLOADED PROCEDURE NOT INVOKED - 1");
   end if;

   Ca2008a1 (B);
   if B then
      Failed ("OVERLOADED PROCEDURE NOT INVOKED - 2");
   end if;

   if Ca2008a2 /= 2 then
      Failed ("OVERLOADED FUNCTION NOT INVOKED - 1");
   end if;

   if Ca2008a2 then
      Failed ("OVERLOADED FUNCTION NOT INVOKED - 2");
   end if;

   Result;
end Ca2008a0m;