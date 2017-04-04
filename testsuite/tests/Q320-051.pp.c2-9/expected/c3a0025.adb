-- C3A0025.A
--
--                            Grant of Unlimited Rights
--
--    AdaCore holds unlimited rights in the software and documentation
--    contained herein. Unlimited rights are the same as those granted
--    by the U.S. Government for older parts of the Ada Conformity
--    Assessment Test Suite, and are defined in DFAR 252.227-7013(a)(19).
--    By making this public release, AdaCore intends to confer upon all
--    recipients unlimited rights equal to those held by the Ada Conformity
--    Assessment Authority. These rights include rights to use, duplicate,
--    release or disclose the released technical data and computer software
--    in whole or in part, in any manner and for any purpose whatsoever,
--    and to have or permit others to do so.
--
--                                   DISCLAIMER
--
--    ALL MATERIALS OR INFORMATION HEREIN RELEASED, MADE AVAILABLE OR
--    DISCLOSED ARE AS IS. ADACORE MAKES NO EXPRESS OR IMPLIED WARRANTY AS
--    TO ANY MATTER WHATSOEVER, INCLUDING THE CONDITIONS OF THE SOFTWARE,
--    DOCUMENTATION OR OTHER INFORMATION RELEASED, MADE AVAILABLE OR
--    DISCLOSED, OR THE OWNERSHIP, MERCHANTABILITY, OR FITNESS FOR A
--    PARTICULAR PURPOSE OF SAID MATERIAL.
--
--                                    Notice
--
--    The ACAA has created and maintains the Ada Conformity Assessment Test
--    Suite for the purpose of conformity assessments conducted in accordance
--    with the International Standard ISO/IEC 18009 - Ada: Conformity
--    assessment of a language processor. This test suite should not be used
--    to make claims of conformance unless used in accordance with
--    ISO/IEC 18009 and any applicable ACAA procedures.
--
--    This test is based on one submitted by AdaCore; AdaCore retains the
--    copyright on the test.
--*
--  OBJECTIVE:
--    Check that Constraint_Error is raised when a null access value is
--    converted to a null excluding anonymous access-to-object type.
--
--  CHANGE HISTORY:
--    30 Apr 2008 RLB Created ACATS test based on C3A0019.
--    02 May 2008 RLB Added missing optimization breakers.
--    18 Jul 2008 RLB Fixed return statement error.
--    07 Nov 2008 RLB Corrected spelling error in objective.
--!

with Report;
procedure C3a0025 is
   subtype Substr is String (1 .. 10);

   type Nn_Substr_Ptr_Array is array (1 .. 3) of not null access Substr;

   function Null_Init return access Substr is
   begin
      return null;
   end Null_Init;

   Aux : aliased Substr := "Hello Ada ";
   function Non_Null_Init return access Substr is
   begin
      return Aux'Access;
   end Non_Null_Init;

   procedure Use_It (Obj : access Substr) is
   -- Use Obj so that the compiler cannot remove the actual from the program as
   -- a dead object.
   begin
      if Obj = null then
         null;
      elsif Obj.all =
        Report.Ident_Str ("ABC")
      then -- Can't match, different lengths
         Report.Comment ("Don't optimize Obj");
      end if;
   end Use_It;

begin
   Report.Test
     ("C3A0025",
      "Check that Constraint_Error is raised when a " &
      "null access value is converted to a null " &
      "excluding anonynous access-to-object type");

   --  Object declaration tests --------------------------------------------

   begin
      declare
         O_1 : not null access Substr;       -- Test (default initialization).
      begin
         Report.Failed ("O_1: Wrong value");
         Use_It (O_1);
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   begin
      declare
         O_2 : not null access Substr :=
           Null_Init;      -- Test (initialization).
      begin
         Report.Failed ("O_2: Wrong value");
         Use_It (O_2);
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   declare
      O_3 : not null access Substr := Non_Null_Init;
   begin
      O_3 := Null_Init;                            -- Test (assignment).
      Report.Failed ("O_3: Wrong value");
      Use_It (O_3);
   exception
      when Constraint_Error =>
         null;
   end;

   --  Array component and aggregate tests ------------------------------

   begin
      declare
         Ao_1 : Nn_Substr_Ptr_Array;       -- Test (default initialization).
      begin
         Report.Failed ("AO_1: Wrong value");
         Use_It (Ao_1 (1));
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   begin
      declare
         Ao_2 : Nn_Substr_Ptr_Array :=
           (Non_Null_Init, Null_Init, Non_Null_Init); -- Test (aggregate).
      begin
         Report.Failed ("AO_2: Wrong value");
         Use_It (Ao_2 (2));
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   declare
      Ao_3 : Nn_Substr_Ptr_Array :=
        (Non_Null_Init, Non_Null_Init, Non_Null_Init);
   begin
      Ao_3 (1) := Null_Init;                -- Test (component assignment).
      Report.Failed ("AO_3: Wrong value");
      Use_It (Ao_3 (1));
   exception
      when Constraint_Error =>
         null;
   end;

   --  Record component and aggregate tests -----------------------------

   begin
      declare
         type Rec is record
            C : not null access Substr;
         end record;
         Ro_1 : Rec;         -- Test (implicit record component default initialization).
      begin
         Report.Failed ("RO_1: Wrong value");
         Use_It (Ro_1.C);
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   begin
      declare
         type Rec is record
            C : not null access Substr;
         end record;
         Ro_2 : Rec := (C => Null_Init);   -- Test (record aggregate).
      begin
         Report.Failed ("RO_2: Wrong value");
         Use_It (Ro_2.C);
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   begin
      declare
         type Rec is record
            C : not null access Substr := Null_Init;
         end record;
         Ro_3 : Rec;         -- Test (explicit record component default initialization).
      begin
         Report.Failed ("RO_3: Wrong value");
         Use_It (Ro_3.C);
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   begin
      declare
         type Rec is record
            C : not null access Substr := Null_Init;
         end record;
         Ro_4 : Rec :=
           (C => Non_Null_Init); -- Default expression not evaluated.
      begin
         Ro_4.C := Null_Init;           -- Test (record component assignment).
         Report.Failed ("RO_4: Wrong value");
         Use_It (Ro_4.C);
      exception
         when Constraint_Error =>
            null;
      end;
   exception
      when Constraint_Error =>
         Report.Failed ("RO_4: Constraint_Error raised");
   end;

   declare
      type Rec is record
         C : not null access Substr := Non_Null_Init;
      end record;
      Ro_5 : Rec;
   begin
      Ro_5.C := Null_Init;           -- Test (record component assignment).
      Report.Failed ("RO_5: Wrong value");
      Use_It (Ro_5.C);
   exception
      when Constraint_Error =>
         null;
   end;

   --  Discriminant tests -----------------------------------------------

   begin
      declare
         type Rec (D : not null access Substr) is record
            Dummy : Integer := 0;
         end record;
         Ro_6 : Rec (Null_Init);        -- Test (discriminant constraint).
      begin
         Ro_6.Dummy := 0;
         Report.Failed ("RO_6: Wrong value");
         Use_It (Ro_6.D);
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   begin
      declare
         type Rec (D : not null access Substr := Null_Init) is limited record
            Dummy : Integer := 0;
         end record;
         Ro_7 : Rec;           -- Test (defaulted discriminant).
      begin
         Ro_7.Dummy := 0;
         Report.Failed ("RO_7: Wrong value");
         Use_It (Ro_7.D);
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   --  Parameter tests --------------------------------------------------

   declare
      procedure Proc_1 (F : not null access Substr) is
      begin
         Use_It (F);
      end Proc_1;
   begin
      begin
         Proc_1 (Null_Init);
         Report.Failed ("Proc_1: Wrong value");
      exception
         when Constraint_Error =>
            null;
      end;
   end;

   begin
      declare
         procedure Proc_2 (F : not null access Substr := Null_Init) is
         begin
            Use_It (F);
         end Proc_2;
      begin
         Proc_2;
         Report.Failed ("Proc_2: Wrong value");
      end;
   exception
      when Constraint_Error =>
         null;
   end;

   --  Result subtype tests ---------------------------------------------

   declare
      function Func_1 (F : access Substr) return not null access Substr is
      begin
         return F;
      end Func_1;
      Obj : access Substr;
   begin
      begin
         Obj := Func_1 (Null_Init);
         Report.Failed ("Func_1: Wrong value");
         Use_It (Obj);
      exception
         when Constraint_Error =>
            null;
      end;
      Obj := Func_1 (Non_Null_Init);
      if Obj /= Non_Null_Init then
         Report.Failed ("Func_1_OK: Wrong value");
      end if;
   end;

   declare
      function Func_2 (F : access Substr) return not null access Substr is
      begin
         return Result : not null access Substr := Aux'Access do
            Result := F;
         end return;
      end Func_2;
      Obj : access Substr;
   begin
      begin
         Obj := Func_2 (Null_Init);
         Report.Failed ("Func_2: Wrong value");
         Use_It (Obj);
      exception
         when Constraint_Error =>
            null;
      end;
      Obj := Func_2 (Non_Null_Init);
      if Obj /= Non_Null_Init then
         Report.Failed ("Func_2_OK: Wrong value");
      end if;
   end;

   --  Formal object tests ----------------------------------------------

   declare
      generic
         F : not null access Substr := Null_Init;
      package Gpack is
         procedure User;
      end Gpack;

      package body Gpack is
         procedure User is
         begin
            Use_It (F);
         end User;
      end Gpack;
   begin
      begin
         declare
            package Inst_1 is new Gpack; -- Object default.
         begin
            Report.Failed ("Inst_1: Wrong value");
            Inst_1.User;
         end;
      exception
         when Constraint_Error =>
            null;
      end;
      begin
         declare
            package Inst_2 is new Gpack (Null_Init);
         begin
            Report.Failed ("Inst_2: Wrong value");
            Inst_2.User;
         end;
      exception
         when Constraint_Error =>
            null;
      end;
      begin
         declare
            package Inst_3 is new Gpack (Non_Null_Init);
         begin
            Inst_3.User;
         end;
      exception
         when Constraint_Error =>
            Report.Failed ("Inst_3: Constraint_Error raised");
      end;
   end;

   Report.Result;
end C3a0025;
