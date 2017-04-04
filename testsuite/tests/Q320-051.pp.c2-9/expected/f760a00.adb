package body F760a00 is

   procedure Initialize (Object : in out Tc_Copy_Check) is
   begin
      Tctouch.Touch ('I'); ----------------------------------------- I
   end Initialize;

   procedure Adjust (Object : in out Tc_Copy_Check) is
   begin
      Tctouch.Touch ('A'); ----------------------------------------- A
   end Adjust;

   procedure Finalize (Object : in out Tc_Copy_Check) is
   begin
      Tctouch.Touch ('F'); ----------------------------------------- F
   end Finalize;

   procedure Use_It (Object : in out Tc_Copy_Check) is
   -- Ensure that Object is not removed by optimization as a dead variable.
   begin
      if Report.Ident_Int (10) /= Object.Val then
         Report.Failed ("Unusual value in TC_Copy_Check");
         -- This should not be possible; we never change the component from its
         -- default value of 10.
      end if;
   end Use_It;

   procedure Use_Cnst (Object : in Tc_Copy_Check) is
   -- Ensure that Object is not removed by optimization as a dead variable.
   begin
      if Report.Ident_Int (10) /= Object.Val then
         Report.Failed ("Unusual value in TC_Copy_Check");
         -- This should not be possible; we never change the component from its
         -- default value of 10.
      end if;
   end Use_Cnst;

   procedure Check_Tc_Copy_Check is
   -- Verify the operation of TC_Copy_Check. This checks that Adjust can be
   -- called.
   begin
      declare
         Obj  : Tc_Copy_Check; -- I
         Cnst : Tc_Copy_Check; -- I
      begin
         Use_It (Obj);
         Use_It (Cnst);
         Obj := Cnst; -- FA
         Use_It (Obj);
      end; -- FF
      Tctouch.Validate ("IIFAFF", "Check_TC_Copy_Check");
   end Check_Tc_Copy_Check;

   procedure Check_Init (Object : in Lim_Rec; Message : in String) is
   begin
      Tctouch.Validate ("I", Message);
   end Check_Init;

   procedure Check_Fin_Lim_Rec (Message : in String) is
   begin
      Tctouch.Validate ("F", Message);
   end Check_Fin_Lim_Rec;

   procedure Use_It (Object : in out Lim_Rec) is
   -- Ensure that Object is not removed by optimization as a dead variable.
   begin
      Use_It (Object.Tc);
   end Use_It;

   procedure Use_Cnst (Object : in Lim_Rec) is
   -- Ensure that Object is not removed by optimization as a dead variable.
   begin
      Use_Cnst (Object.Tc);
   end Use_Cnst;

   procedure Check_Init (Object : in Lim_Array; Message : in String) is
   begin
      Tctouch.Validate ((1 .. Object'Length => 'I'), Message);
   end Check_Init;

   procedure Check_Fin_Lim_Array (Length : in Natural; Message : in String) is
   begin
      Tctouch.Validate ((1 .. Length => 'F'), Message);
   end Check_Fin_Lim_Array;

   procedure Use_It (Object : in out Lim_Array) is
   -- Ensure that Object is not removed by optimization as a dead variable.
   begin
      for I in Object'Range loop
         Use_It (Object (I).Tc);
      end loop;
   end Use_It;

   procedure Check_Init (Object : in Lim_Tagged'Class; Message : in String) is
   begin
      Tctouch.Validate ("II", Message);
   end Check_Init;

   procedure Check_Fin_Lim_Tagged (Message : in String) is
   begin
      Tctouch.Validate ("FF", Message);
   end Check_Fin_Lim_Tagged;

   procedure Use_It (Object : in out Lim_Tagged'Class) is
   -- Ensure that Object is not removed by optimization as a dead variable.
   begin
      Use_It (Object.Tc);
      Use_It (Object.R);
   end Use_It;

   procedure Check_Init (Object : in Prot; Message : in String) is
   begin
      Tctouch.Validate ("I", Message);
   end Check_Init;

   procedure Check_Fin_Prot (Message : in String) is
   begin
      Tctouch.Validate ("F", Message);
   end Check_Fin_Prot;

   procedure Use_It (Object : in out Prot) is
   -- Ensure that Object is not removed by optimization as a dead variable.
   begin
      Object.Use_It;
   end Use_It;

   protected body Prot is
      function Get return Natural is
      begin
         return Value;
      end Get;

      procedure Set (Val : in Natural) is
      begin
         Value := Val;
      end Set;

      procedure Use_It is
      begin
         Use_It (Tc);
      end Use_It;
   end Prot;

   procedure Check_Init (Object : in Lim_Comp; Message : in String) is
   begin
      Tctouch.Validate ("II", Message);
   end Check_Init;

   procedure Check_Fin_Lim_Comp (Message : in String) is
   begin
      Tctouch.Validate ("FF", Message);
   end Check_Fin_Lim_Comp;

   procedure Use_It (Object : in out Lim_Comp) is
   -- Ensure that Object is not removed by optimization as a dead variable.
   begin
      Use_It (Object.Tc);
      Object.P.Use_It;
   end Use_It;

end F760a00;