with F393a00_0;
package body C393a06_0 is

   procedure Swap (A, B : in out Organism) is
   begin
      F393a00_0.Tc_Touch ('A');  ------------------------------------------- A
      if A.In_Kingdom /= B.In_Kingdom then
         F393a00_0.Tc_Touch ('X');
         raise Incompatible;
      else
         declare
            T : constant Organism := A;
         begin
            A := B;
            B := T;
         end;
      end if;
   end Swap;

   function Create return Organism is
      Widget : Organism;
   begin
      F393a00_0.Tc_Touch ('B'); ------------------------------------------- B
      Initialize (Widget);
      Widget.In_Kingdom := Unspecified;
      return Widget;
   end Create;

   procedure Initialize
     (The_Entity     : in out Organism;
      In_The_Kingdom :        Kingdoms)
   is
   begin
      F393a00_0.Tc_Touch ('C'); ------------------------------------------- C
      F393a00_1.Initialize (F393a00_1.Object (The_Entity));
      The_Entity.In_Kingdom := In_The_Kingdom;
   end Initialize;

   function Kingdom (Of_The_Entity : Organism) return Kingdoms is
   begin
      F393a00_0.Tc_Touch ('D'); ------------------------------------------- D
      return Of_The_Entity.In_Kingdom;
   end Kingdom;

   procedure Tc_Check
     (An_Entity   : Organism'Class;
      In_Kingdom  : Kingdoms;
      Initialized : Boolean)
   is
   begin
      if F393a00_1.Initialized (An_Entity) /= Initialized then
         F393a00_0.Tc_Touch
           ('-'); ------------------------------------------- -
      elsif An_Entity.In_Kingdom /= In_Kingdom then
         F393a00_0.Tc_Touch
           ('!'); ------------------------------------------- !
      else
         F393a00_0.Tc_Touch
           ('+'); ------------------------------------------- +
      end if;
   end Tc_Check;

end C393a06_0;
