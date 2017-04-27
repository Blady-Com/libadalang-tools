-- C97204A.ADA

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
-- CHECK THAT THE EXCEPTION TASKING_ERROR WILL BE RAISED IF THE CALLED
--     TASK HAS ALREADY COMPLETED ITS EXECUTION AT THE TIME OF THE
--     CONDITIONAL_ENTRY_CALL.

-- RM 5/28/82
-- SPS 11/21/82
-- PWN 09/11/94 REMOVED PRAGMA PRIORITY FOR ADA 9X.

with Report; use Report;
with System; use System;
procedure C97204a is

-- THE TASK WILL HAVE HIGHER PRIORITY ( PRIORITY'LAST )

begin

   -------------------------------------------------------------------

   Test
     ("C97204A",
      "CHECK THAT THE EXCEPTION  TASKING_ERROR  WILL" &
      " BE RAISED IF THE CALLED TASK HAS ALREADY" &
      " COMPLETED ITS EXECUTION AT THE TIME OF THE" &
      " CONDITIONAL_ENTRY_CALL");

   declare

      task type T_Type is

         entry E;

      end T_Type;

      T_Object1 : T_Type;

      task body T_Type is
         Busy : Boolean := False;
      begin

         null;

      end T_Type;

   begin

      for I in 1 .. 5 loop
         exit when T_Object1'Terminated;
         delay 10.0;
      end loop;

      if not T_Object1'Terminated then
         Comment ("TASK NOT YET TERMINATED (AFTER 50 S.)");
      end if;

      begin

         select
            T_Object1.E;
            Failed ("CALL WAS NOT DISOBEYED");
         else
            Failed ("'ELSE' BRANCH TAKEN INSTEAD OF TSKG_ERR");
         end select;

         Failed ("EXCEPTION NOT RAISED");

      exception

         when Tasking_Error =>
            null;

         when others =>
            Failed ("WRONG EXCEPTION RAISED");

      end;

   end;

   -------------------------------------------------------------------

   Result;

end C97204a;