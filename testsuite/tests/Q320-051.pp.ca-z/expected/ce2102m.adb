-- CE2102M.ADA

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
--     CHECK TO SEE THAT STATUS_ERROR IS RAISED WHEN PERFORMING ILLEGAL
--     OPERATIONS ON OPENED OR UNOPENED FILES OF TYPE DIRECT_IO.

--          B) UNOPENED FILES

-- HISTORY:
--     SPW 02/24/87  CREATED ORIGINAL TEST.

with Report; use Report;
with Direct_Io;

procedure Ce2102m is

   package Dir_Io is new Direct_Io (Integer);
   use Dir_Io;

   Test_File_One : Dir_Io.File_Type;
   Str           : String (1 .. 10);
   Fl_Mode       : Dir_Io.File_Mode;

begin

   Test
     ("CE2102M",
      "CHECK THAT STATUS_ERROR IS RAISED WHEN " &
      "PERFORMING ILLEGAL OPERATIONS ON UNOPENED " &
      "FILES OF TYPE DIRECT_IO");

-- CHECK TO SEE THAT PROPER EXCEPTIONS ARE RAISED WHEN PERFORMING OPERATIONS ON
-- AN UNOPENED FILE

-- CLOSE AN UNOPENED FILE

   begin
      Close (Test_File_One);
      Failed
        ("STATUS_ERROR NOT RAISED WHEN AN UNOPENED FILE " &
         "IS USED IN A CLOSE OPERATION");
   exception
      when Status_Error =>
         null;
      when others =>
         Failed ("WRONG EXCEPTION RAISED ON CLOSE");
   end;

-- DELETE AN UNOPENED FILE

   begin
      Delete (Test_File_One);
      Failed
        ("STATUS_ERROR NOT RAISED WHEN AN UNOPENED FILE " &
         "IS USED IN A DELETE OPERATION");
   exception
      when Status_Error =>
         null;
      when others =>
         Failed ("WRONG EXCEPTION RAISED ON DELETE");
   end;

-- RESET UNOPENED FILE

   begin
      Reset (Test_File_One);
      Failed
        ("STATUS_ERROR NOT RAISED WHEN AN UNOPENED FILE " &
         "IS USED IN A RESET");
   exception
      when Status_Error =>
         null;
      when others =>
         Failed ("WRONG EXCEPTION RAISED ON RESET");
   end;

   begin
      Reset (Test_File_One, In_File);
      Failed
        ("STATUS_ERROR NOT RAISED WHEN AN UNOPENED FILE " &
         "IS USED IN A RESET WITH MODE PARAMETER");
   exception
      when Status_Error =>
         null;
      when others =>
         Failed ("WRONG EXCEPTION RAISED ON RESET WITH " & "MODE PARAMETER");
   end;

-- ATTEMPT TO DETERMINE MODE OF UNOPENED FILE

   begin
      Fl_Mode := Mode (Test_File_One);
      Failed
        ("STATUS_ERROR NOT RAISED WHEN AN UNOPENED FILE " &
         "IS USED IN A MODE OPERATION");
   exception
      when Status_Error =>
         null;
      when others =>
         Failed ("WRONG EXCEPTION RAISED ON MODE");
   end;

-- ATTEMPT TO DETERMINE NAME OF UNOPENED FILE

   begin
      Str := Name (Test_File_One);
      Failed
        ("STATUS_ERROR NOT RAISED WHEN AN UNOPENED FILE " &
         "IS USED IN A NAME OPERATION");
   exception
      when Status_Error =>
         null;
      when others =>
         Failed ("WRONG EXCEPTION RAISED ON NAME");
   end;

--ATTEMPT TO DETERMINE FORM OF UNOPENED FILE

   begin
      Str := Form (Test_File_One);
      Failed
        ("STATUS_ERROR NOT RAISED WHEN AN UNOPENED FILE " &
         "IS USED IN A FORM OPERATION");
   exception
      when Status_Error =>
         null;
      when others =>
         Failed ("WRONG EXCEPTION RAISED ON FORM");
   end;

   Result;
end Ce2102m;