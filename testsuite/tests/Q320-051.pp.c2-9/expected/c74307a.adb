-- C74307A.ADA

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
-- OBJECTIVE:
--     CHECK THAT AN EXPLICIT CONSTRAINT MAY BE GIVEN IN THE SUBTYPE
--     INDICATION OF THE FULL DECLARATION OF A DEFERRED CONSTANT.

-- HISTORY:
--     BCB 03/14/88  CREATED ORIGINAL TEST.

with Report; use Report;

procedure C74307a is

   package P is
      type T (D : Integer) is private;
      C : constant T;
   private
      type T (D : Integer) is record
         null;
      end record;
      C : constant T (2) := (D => 2);
   end P;

   use P;

begin
   Test
     ("C74307A",
      "CHECK THAT AN EXPLICIT CONSTRAINT MAY BE " &
      "GIVEN IN THE SUBTYPE INDICATION OF THE FULL " &
      "DECLARATION OF A DEFERRED CONSTANT");

   if C.D /= 2 then
      Failed ("IMPROPER RESULTS FOR C.D");
   end if;

   Result;
end C74307a;
