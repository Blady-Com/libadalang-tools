     --===================================================================--

with Cc51007_1;
with Cc51007_2;
with Cc51007_3;
with Cc51007_4;

with Ada.Calendar;
with Report;
procedure Cc51007 is

   package Alert_Support renames Cc51007_4;

   Ext : Alert_Support.Extended_Alert;

   Tc_Result : Alert_Support.Extended_Alert;

   Tc_Low_Expected : constant Alert_Support.Extended_Alert :=
     (Time_Of_Arrival => Ada.Calendar.Time_Of (1_984, 1, 1),
      Message         => "Low Alert!",
      Addendum        => "No comment");

   Tc_Med_Expected : constant Alert_Support.Extended_Alert :=
     (Time_Of_Arrival => Ada.Calendar.Time_Of (2_001, 1, 1),
      Message         => "Med Alert!",
      Addendum        => "No comment");

   Tc_Ext_Expected : constant Alert_Support.Extended_Alert := Tc_Low_Expected;

   use type Alert_Support.Extended_Alert;

begin
   Report.Test
     ("CC51007",
      "Check that, for a generic formal derived type " &
      "whose ancestor type has abstract primitive subprograms, " &
      "neither the formal derived type nor its descendants need " &
      "be abstract, and that objects of, components of, " &
      "allocators of, aggregates of, and nonabstract functions " &
      "returning these types are legal. Check that calls to the " &
      "abstract primitive subprograms of the ancestor dispatch " &
      "to the bodies corresponding to the tag of the actual " &
      "parameters");

   Tc_Result := Alert_Support.Annotate_Alert (Cc51007_1.Low);  -- Dispatching
   -- call.
   if Tc_Result /= Tc_Low_Expected then
      Report.Failed ("Wrong results from dispatching call (Low_Alert)");
   end if;

   Tc_Result := Alert_Support.Annotate_Alert (Cc51007_2.Med);  -- Dispatching
   -- call.
   if Tc_Result /= Tc_Med_Expected then
      Report.Failed ("Wrong results from dispatching call (Medium_Alert)");
   end if;

   Tc_Result := Alert_Support.Annotate_Alert (Ext);   -- Results in dispatching
   -- call.
   if Tc_Result /= Tc_Ext_Expected then
      Report.Failed ("Wrong results from dispatching call (Extended_Alert)");
   end if;

   Report.Result;
end Cc51007;