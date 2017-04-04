with C760014_0;
with Report; use Report;
procedure C760014 is
   Tc_Counter : aliased C760014_0.Tc_Count;
begin
   Test ("C760014", "Check that Ada.Finalization is a declared pure package");
   declare
      Test : C760014_0.Test_Type (Tc_Counter'Access);
   begin
      if Tc_Counter.Init_Count /= 1 then
         Failed ("Initialize not called for stand-alone object");
      end if;
      if Tc_Counter.Fin_Count /= 0 then
         Failed ("Finalize called prematurely for stand-alone object");
      end if;
   end; -- Test finalized here.
   if Tc_Counter.Fin_Count /= 1 then
      Failed ("Finalize not called for stand-alone object");
   end if;
   if Tc_Counter.Init_Count > 1 then
      Failed ("Initialize called too many times for stand-alone object");
   end if;

   -- Reset counter:
   Tc_Counter := (0, 0);

   declare
      type Rec is record
         Test1, Test2 : C760014_0.Test_Type (Tc_Counter'Access);
      end record;

      Rec_Object : Rec;
   begin
      if Tc_Counter.Init_Count /= 2 then
         Failed ("Initialize not called for components");
      end if;
      if Tc_Counter.Fin_Count /= 0 then
         Failed ("Finalize called prematurely for components");
      end if;
   end; -- Rec_Object finalized here.
   if Tc_Counter.Fin_Count /= 2 then
      Failed ("Finalize not called for components");
   end if;
   if Tc_Counter.Init_Count > 2 then
      Failed ("Initialize called too many times for components");
   end if;

   Result;
end C760014;
